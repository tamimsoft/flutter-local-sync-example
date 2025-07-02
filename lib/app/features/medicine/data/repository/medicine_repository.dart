import 'package:injectable/injectable.dart';
import '/app/config/injectable/injection.dart';
import '/app/core/services/sync/repository/generic_sync_repository.dart';
import '../../adapter/medicine_sync_adapter.dart';
import '/app/features/medicine/data/model/medicine_model.dart';

/// A repository class responsible for managing medicine data using a generic synchronization mechanism.
///
/// This class utilizes [GenericSyncRepository] to handle data operations while interfacing with
/// [MedicineSyncAdapter] to adapt medicine-specific logic during synchronization processes.
///
@lazySingleton
class MedicineRepository {
  final GenericSyncRepository<MedicineModel> _genericRepo =
      GenericSyncRepository<MedicineModel>(getIt(), getIt());
  final MedicineSyncAdapter _adapter;

  /// Creates an instance of [MedicineRepository], requiring a [MedicineSyncAdapter].
  MedicineRepository(this._adapter);

  /// Saves a single medicine model to the repository.
  Future<void> save(MedicineModel model) => _genericRepo.save(_adapter, model);

  /// Deletes a medicine by its unique identifier.
  Future<void> delete(String id) => _genericRepo.delete(_adapter, id);

  /// Saves a list of medicine models in bulk.
  Future<void> saveAll(List<MedicineModel> list) =>
      _genericRepo.saveAll(_adapter, list);

  /// Synchronizes local medicine data with remote sources.
  Future<void> sync() => _genericRepo.sync(_adapter);

  /// Retrieves all medicine models currently stored.
  Future<List<MedicineModel>> getAll() => _genericRepo.getAll(_adapter);
}
