import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '/app/core/services/database/app_db.dart';
import '/app/core/services/sync/ui/cubit/sync_status_cubit.dart';
import '/app/core/utils/connectivity_helper.dart';
import '/app/core/utils/sync_storage_manager.dart';
import 'package:watcher/watcher.dart';

@singleton
class SyncWatcherService {
  final ConnectivityHelper _connectivityHelper;
  final SyncStatusCubit _syncStatusCubit;

  /// Subscription to connectivity events
  StreamSubscription<bool>? _connectivitySubscription;

  /// Active file watchers for each table
  final Map<DbTable, StreamSubscription<WatchEvent>> _watchers = {};

  /// Debounce timer for file changes
  Timer? _debounceTimer;

  /// Sync trigger callback injected during init
  late final Future<void> Function(DbTable table) _onChange;

  SyncWatcherService(this._connectivityHelper, this._syncStatusCubit);

  /// Initializes the sync manager with sync logic
  void init({required Future<void> Function(DbTable table) onChange}) {
    _onChange = onChange;
  }

  /// Starts watching file only when online
  Future<void> startWatching(DbTable table) async {
    _connectivitySubscription?.cancel();
    // 1. Check current status on startup
    final hasInternet = await _connectivityHelper.checkNow();
    if (hasInternet) {
      await _checkAndTriggerSync(table); // ✅ Auto-sync immediately
    } else {
      _syncStatusCubit.setOffline();
    }

    // 2. Listen for future changes
    _connectivitySubscription = _connectivityHelper.onOnline.listen((
      isOnline,
    ) async {
      debugPrint('🌐 Connectivity changed: $isOnline');
      if (isOnline) {
        await _checkAndTriggerSync(table); // ✅ Sync when online comes back
      } else {
        _syncStatusCubit.setOffline();
      }
    });
  }

  /// Checks real internet and triggers sync if possible
  Future<void> _checkAndTriggerSync(DbTable table) async {
    final hasInternet = await _connectivityHelper.checkNow();

    if (!hasInternet) {
      _stopFileWatcher(table);
      _syncStatusCubit.setOffline();
      return;
    }
    _syncStatusCubit.setIdle();

    await _startFileWatcher(table);

    try {
      await _onChange(table);
    } catch (e) {
      debugPrint('❌ Sync error: $e');
      _syncStatusCubit.setError();
    }
  }

  /// Starts file watcher for a specific table
  Future<void> _startFileWatcher(DbTable table) async {
    if (_watchers.containsKey(table)) return; // already watching

    final file = await _getTableFile(table);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }

    final watcher = FileWatcher(file.path);
    final subscription = watcher.events.listen((event) {
      if (event.type == ChangeType.MODIFY) {
        debugPrint('📝 File changed: ${file.path}');
        _debouncedFileChange(table);
      }
    });

    _watchers[table] = subscription;
    debugPrint('👁️ Started watching: ${file.path}');
  }

  /// Stops file watcher
  void _stopFileWatcher(DbTable table) {
    final sub = _watchers.remove(table);
    sub?.cancel();
    debugPrint('🛑 Stopped watching: ${table.name}');
  }

  /// Called when file changes, but debounced
  void _debouncedFileChange(DbTable table) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _onChange(table);
    });
  }

  /// Gets the JSON file associated with a table
  Future<File> _getTableFile(DbTable table) async {
    final dir = await SyncStorageManager.getSyncDirectory();
    return File('${dir.path}/${table.name}.json');
  }

  /// Disposes all listeners and resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _debounceTimer?.cancel();
    for (var sub in _watchers.values) {
      sub.cancel();
    }
    _watchers.clear();
    debugPrint('🧹 SyncManagerService disposed');
  }
}
