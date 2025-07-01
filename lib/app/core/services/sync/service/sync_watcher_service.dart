import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:watcher/watcher.dart';
import '/app/core/utils/shared_file_util.dart';

/// A service class responsible for monitoring file changes related to synchronization.
/// 
/// This singleton class watches for modifications in table-specific JSON files and 
/// notifies listeners after a debounce period. It ensures efficient change detection 
/// and prevents excessive notifications using a timer-based debouncing mechanism.
@singleton
class SyncWatcherService {
  /// Internal map storing active watchers keyed by their respective table names.
  final Map<String, StreamSubscription<WatchEvent>> _watchers = {};

  /// Callback function that is triggered when a file modification is detected.
  late final void Function(String) _onChange;

  /// Initializes the service with a callback function.
  ///
  /// [onChange] is called when a file update is detected after debouncing.
  void init({required void Function(String) onChange}) {
    _onChange = onChange;
  }

  /// Starts watching a specific table's JSON file for modifications.
  ///
  /// Ensures the file exists (creates it if necessary), then initializes a watcher.
  /// On modification events, triggers a debounced notification via [_debouncedOnChange].
  Future<void> startWatching(String table) async {
    final file = await _getTableFile(table);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }

    final watcher = FileWatcher(file.path);
    final subscription = watcher.events.listen((event) {
      if (event.type == ChangeType.MODIFY) {
        debugPrint('🔁 [Watcher] File updated: ${file.path}');
        _debouncedOnChange(table);
      }
    });

    _watchers[table] = subscription;
  }

  /// Stops watching a specific table's file.
  void stopWatching(String table) {
    _watchers[table]?.cancel();
    _watchers.remove(table);
  }

  /// Releases all watchers and cleans up resources.
  void dispose() {
    _watchers.forEach((_, sub) => sub.cancel());
    _watchers.clear();
  }

  /// Timer used to debounce file change notifications.
  Timer? _debounce;

  /// Triggers the `onChange` callback after a debounce delay to avoid rapid updates.
  void _debouncedOnChange(String table) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _onChange(table);
    });
  }

  /// Returns the file associated with a specific table.
  Future<File> _getTableFile(String table) async {
    final dir = await SyncStorageManager.getSharedDirectory();
    return File('${dir.path}/$table.json');
  }
}
