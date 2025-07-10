import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SyncStorageManager {
  /// Gets the sync directory for SyncStore.
  /// Creates and returns a platform-specific directory used for synchronization.
  static Future<Directory> getSyncDirectory() async {
    Directory dir;

    if (Platform.isAndroid) {
      final hasPermission = await requestStoragePermission();

      if (!hasPermission) {
        throw FileSystemException("❌ Storage permission denied");
      }

      // Path to shared internal storage (visible in file managers)
      const path = '/storage/emulated/0/SyncStore';

      dir = Directory(path);

      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    } else if (Platform.isIOS) {
      throw UnsupportedError(
        "iOS does not allow access to shared external storage.",
      );
    } else if (Platform.isWindows) {
      final userRoot =
          Platform.environment['USERPROFILE'] ?? 'C:\\Users\\Default';

      dir = Directory('$userRoot\\SyncStore');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    } else if (Platform.isLinux || Platform.isMacOS) {
      final home = Platform.environment['HOME'] ?? '/home/unknown';

      dir = Directory('$home/SyncStore');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
    debugPrint('✅ Sync directory path: ${dir.path}');
    return dir;
  }

  /// Request storage permission specifically on Android.
  ///
  /// Handles both legacy storage permissions and scoped storage requirements for Android 11+.
  ///
  /// Returns `true` if permission is already granted or successfully requested; otherwise `false`.
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    // Already granted
    if (await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    // Request storage first (Android < 11)
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) return true;

    // Request manageExternalStorage (Android 11+)
    final manageStatus = await Permission.manageExternalStorage.request();
    if (manageStatus.isGranted) return true;

    // Optional: Check if permission was permanently denied
    if (storageStatus.isPermanentlyDenied || manageStatus.isPermanentlyDenied) {
      // Open app settings if denied forever
      await openAppSettings();
    }

    return false;
  }
}
