import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../ui/cubit/sync_status_cubit.dart';
import '/app/core/utils/connectivity_helper.dart';
import '/app/features/medicine/data/repository/medicine_repository.dart';

/// Manages automatic and manual synchronization based on network availability.
/// Listens for online status changes and triggers debounced sync operations.
/// Maintains state via [SyncStatusCubit] and uses [MedicineRepository] for actual data sync.
@lazySingleton
class SyncScheduler {
  final ConnectivityHelper _connectivityHelper;
  final SyncStatusCubit _syncStatusCubit;
  final MedicineRepository _medicineRepository;

  StreamSubscription<bool>? _subscription;
  Timer? _debounceTimer;

  SyncScheduler(
    this._connectivityHelper,
    this._medicineRepository,
    this._syncStatusCubit,
  );

  /// Starts listening to connectivity changes.
  /// Cancels any previous subscription to avoid duplicates.
  void start() {
    _subscription?.cancel(); // Prevent duplicate listeners

    _subscription = _connectivityHelper.onOnline.listen((isOnline) async {
      debugPrint('🌐 Online status: $isOnline');
      if (isOnline) {
        await _checkAndSync(); // Check real internet before syncing
      } else {
        _syncStatusCubit.setOffline();
      }
    });
  }

  /// Verifies actual internet access before initiating sync.
  Future<void> _checkAndSync() async {
    final hasInternet = await _connectivityHelper.checkNow();
    if (!hasInternet) {
      debugPrint('⚠️ No actual internet access.');
      _syncStatusCubit.setOffline();
      return;
    }

    _syncStatusCubit.setSyncing();
    _debouncedSync();
  }

  /// Delays sync execution by 5 seconds to avoid redundant calls.
  void _debouncedSync() {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(seconds: 5), () async {
      try {
        debugPrint('🔁 Sync triggered by internet connection');
        await _medicineRepository.sync();
        _syncStatusCubit.setSynced();

        await Future.delayed(const Duration(seconds: 3));
        _syncStatusCubit.setIdle();
      } catch (e, st) {
        debugPrint('❌ Sync failed: $e\n$st');
        _syncStatusCubit.setError();
      }
    });
  }

  /// Forces immediate synchronization regardless of auto-sync rules.
  Future<void> forceSync() async {
    final hasInternet = await _connectivityHelper.checkNow();
    if (!hasInternet) {
      debugPrint('⚠️ No internet for manual sync');
      _syncStatusCubit.setOffline();
      return;
    }

    debugPrint('🔁 Manual sync triggered');
    _syncStatusCubit.setSyncing();

    try {
      await _medicineRepository.sync();
      _syncStatusCubit.setSynced();
      await Future.delayed(const Duration(seconds: 3));
      _syncStatusCubit.setIdle();
    } catch (e) {
      debugPrint('❌ Manual sync failed: $e');
      _syncStatusCubit.setError();
    }
  }

  /// Releases resources when the scheduler is no longer needed.
  void dispose() {
    debugPrint('🧹 SyncScheduler: disposing');
    _subscription?.cancel();
    _debounceTimer?.cancel();
  }
}
