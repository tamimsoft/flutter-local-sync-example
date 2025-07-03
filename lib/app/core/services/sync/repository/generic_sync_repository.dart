import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '/app/config/injectable/injection.dart';
import '../ui/cubit/sync_status_cubit.dart';
import '/app/core/services/database/app_db.dart';
import '../adapter/generic_sync_adapter.dart';
import '../service/sync_service.dart';

/// A generic repository class that manages data synchronization between local storage and a remote service.
///
/// This class provides CRUD operations with automatic syncing to a remote source when connection is available.
@lazySingleton
class GenericSyncRepository<T> {
  GenericSyncRepository(this._db, this._syncService);

  final SyncStatusCubit _syncStatusCubit = getIt();
  final AppDb _db;
  final SyncService _syncService;

  /// Saves or updates a single model both locally and remotely (if online).
  Future<void> save(GenericSyncAdapter<T> adapter, T model) async {
    await _db.upsert<T>(
      table: adapter.table,
      id: adapter.getId(model),
      data: model,
    );

    if (await _syncService.hasConnection()) {
      await _syncService.push(
        table: adapter.table.name,
        data: adapter.toJson(model),
      );
    }
  }

  /// Deletes a model by ID both locally and remotely (if online).
  Future<void> delete(GenericSyncAdapter<T> adapter, String id) async {
    await _db.delete<T>(table: adapter.table, id: id);

    if (await _syncService.hasConnection()) {
      await _syncService.delete(table: adapter.table.name, id: id);
    }
  }

  /// Saves or updates multiple models, performing remote sync once if connected.
  Future<void> saveAll(GenericSyncAdapter<T> adapter, List<T> models) async {
    final online = await _syncService.hasConnection();
    for (final model in models) {
      await _db.upsert<T>(
        table: adapter.table,
        id: adapter.getId(model),
        data: model,
      );

      if (online) {
        await _syncService.push(
          table: adapter.table.name,
          data: adapter.toJson(model),
        );
      }
    }
  }

  /// Synchronizes local data with remote service:
  /// 1. Pushes local changes made while offline.
  /// 2. Pulls the latest data from the remote service.
  Future<void> sync(GenericSyncAdapter<T> adapter) async {
    if (!await _syncService.hasConnection()) return;

    _syncStatusCubit.setSyncing();
    await _syncService.init();

    // ✅ 1. Push local edits made offline
    final localList = await _db.findAll<T>(
      table: adapter.table,
      toJson: adapter.toJson,
    );

    for (final local in localList) {
      if (await _shouldPush(
        adapter.table,
        adapter.getId(local),
        adapter.getUpdatedAt(local),
      )) {
        await _syncService.push(
          table: adapter.table.name,
          data: adapter.toJson(local),
        );
      }
    }

    // ✅ 2. Pull latest from remote
    final List<Map<String, dynamic>> list = await _syncService.pull(
      table: adapter.table.name,
    );

    for (final item in list) {
      final T remote = adapter.fromJson(item);
      final T? local = await _db.findById<T>(
        table: adapter.table,
        id: adapter.getId(remote),
      );

      if (local == null ||
          adapter.getUpdatedAt(remote).isAfter(adapter.getUpdatedAt(local))) {
        await _db.upsert<T>(
          table: adapter.table,
          id: adapter.getId(remote),
          data: remote,
        );
      }
    }

    _syncStatusCubit.setSynced();
  }

  /// Retrieves all locally stored items of the given type.
  Future<List<T>> getAll(GenericSyncAdapter<T> adapter) async {
    return await _db.findAll<T>(table: adapter.table);
  }

  /// Checks if the local item is newer than the remote one.
  Future<bool> _shouldPush(
    DbTable table,
    String id,
    DateTime localUpdatedAt,
  ) async {
    try {
      final remoteItem = await _syncService.pullOne(table: table.name, id: id);

      if (remoteItem.isEmpty) return true; // Doesn't exist remotely

      final remoteUpdatedAt = DateTime.parse(remoteItem['updatedAt']);
      return localUpdatedAt.isAfter(remoteUpdatedAt); // true if local is newer
    } catch (e) {
      debugPrint('❌ shouldPush error: $e');
      return false;
    }
  }
}
