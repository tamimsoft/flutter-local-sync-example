import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import 'native_storage_service.dart';

class SyncStorageManager {
  /// Get the shared directory for SyncStore.
  /// 
  /// Creates and returns a platform-specific directory used for synchronization. 
  /// On Android, it requires proper permissions to access external storage.
  /// For desktop platforms (Linux, macOS, Windows), it creates a directory in the home path.
  ///
  /// Throws [FileSystemException] if storage permission is denied on Android.
  /// Throws [UnsupportedError] if the platform isn't supported.
  static Future<Directory> getSharedDirectory() async {
    Directory dir;

    if (Platform.isAndroid) {
      // Request permission if needed
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        throw FileSystemException("Storage permission denied");
      }
      // Use method channel to create the directory
      final path = await NativeStorageService.createSyncFolder();
      debugPrint("✅ Sync folder path: $path");

      dir = Directory(path!);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final home = Platform.environment['HOME']!;
      dir = Directory('$home/SyncStore');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    } else {
      throw UnsupportedError('Unsupported platform for shared file');
    }

    debugPrint('Shared directory: ${dir.path}');
    return dir;
  }

  /// Request storage permission specifically on Android.
  /// 
  /// Handles both legacy storage permissions and scoped storage requirements for Android 11+.
  ///
  /// Returns `true` if permission is already granted or successfully requested; otherwise `false`.
  static Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    if (await Permission.storage.isGranted) {
      return true;
    }

    // For Android 11+
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    // Request both
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) return true;

    // For Android 11+, explicitly request manageExternalStorage
    final manageStatus = await Permission.manageExternalStorage.request();
    return manageStatus.isGranted;
  }
}
