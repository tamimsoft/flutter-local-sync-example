import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A service class that provides access to native storage functionalities via method channels.
class NativeStorageService {
  /// The [MethodChannel] used for communication with the native platform.
  static const MethodChannel _channel = MethodChannel('sync/native_storage');

  /// Creates a synchronized folder on the native storage.
  ///
  /// Returns the path of the created folder if successful, otherwise returns null.
  static Future<String?> createSyncFolder() async {
    try {
      final String? result = await _channel.invokeMethod('createSyncFolder');
      return result;
    } catch (e) {
      debugPrint('❌ Failed to create folder: $e');
      return null;
    }
  }
}
