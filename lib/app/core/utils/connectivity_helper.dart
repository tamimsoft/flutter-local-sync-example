import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// A singleton helper class to monitor network connectivity status.
///
/// Provides both a [Stream] for real-time updates and a method for
/// one-time connectivity checks. Users should call [dispose] when
/// the helper is no longer needed to close the stream properly.
@singleton
class ConnectivityHelper {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  /// Stream that emits `true` if the device is online, or `false` if offline.
  Stream<bool> get onOnline => _controller.stream;

  /// Initializes the connectivity listener to monitor network changes.
  ConnectivityHelper() {
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      final bool isOnline =
          results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none);
      _controller.add(isOnline);
    });
  }

  /// Performs a one-time check to determine if the device has internet access.
  ///
  /// Returns a [Future<bool>] that resolves to `true` if any active connection exists.
  Future<bool> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);
  }

  /// Closes the stream to prevent memory leaks. Should be called when this helper is no longer in use.
  void dispose() => _controller.close();
}
