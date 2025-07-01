import 'package:injectable/injectable.dart';
import '/app/core/services/database/app_db.dart';
import '../adapter/generic_sync_adapter.dart';
import '../service/sync_service.dart';

/// A generic repository class that manages data synchronization between local storage and a remote service.
/// 
/// This class provides CRUD operations with automatic syncing to a remote source when connection is available.
@lazySingleton
class GenericSyncRepository<T> {
  GenericSyncRepository(this._db, this._syncService);

  final AppDb _db;
  final SyncService _syncService;

  /// Saves or updates a single model both locally and remotely (if online).
  Future<void> save(GenericSyncAdapter<T> adapter, T model) async {
    await _db.upsert<T>(
      table: DbTable.fromName(adapter.table),
      id: adapter.getId(model),
      data: model,
    );

    if (await _syncService.hasConnection()) {
      await _syncService.push(
        table: adapter.table,
        data: adapter.toJson(model),
      );
    }
  }

  /// Deletes a model by ID both locally and remotely (if online).
  Future<void> delete(GenericSyncAdapter<T> adapter, String id) async {
    await _db.delete<T>(table: DbTable.fromName(adapter.table), id: id);

    if (await _syncService.hasConnection()) {
      await _syncService.delete(table: adapter.table, id: id);
    }
  }

  /// Saves or updates multiple models, performing remote sync once if connected.
  Future<void> saveAll(GenericSyncAdapter<T> adapter, List<T> models) async {
    final online = await _syncService.hasConnection();
    for (final model in models) {
      await _db.upsert<T>(
        table: DbTable.fromName(adapter.table),
        id: adapter.getId(model),
        data: model,
      );

      if (online) {
        await _syncService.push(
          table: adapter.table,
          data: adapter.toJson(model),
        );
      }
    }
  }

  /// Synchronizes remote data with local storage, pulling updates from the server.
  Future<void> sync(GenericSyncAdapter<T> adapter) async {
    if (!await _syncService.hasConnection()) return;

    await _syncService.init();

    final List<Map<String, dynamic>> list = await _syncService.pull(
      table: adapter.table,
    );
    for (final item in list) {
      final T remote = adapter.fromJson(item);
      final T? local = await _db.findById<T>(
        table: DbTable.fromName(adapter.table),
        id: adapter.getId(remote),
      );
      if (local == null ||
          adapter.getUpdatedAt(remote).isAfter(adapter.getUpdatedAt(local))) {
        await _db.upsert<T>(
          table: DbTable.fromName(adapter.table),
          id: adapter.getId(remote),
          data: remote,
        );
      }
    }
  }

  /// Retrieves all locally stored items of the given type.
  Future<List<T>> getAll(GenericSyncAdapter<T> adapter) async {
    return await _db.findAll<T>(table: DbTable.fromName(adapter.table));
  }
}
