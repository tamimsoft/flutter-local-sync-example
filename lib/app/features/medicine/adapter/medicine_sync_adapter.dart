import 'package:injectable/injectable.dart';
import '/app/core/services/database/app_db.dart';

import '../data/model/medicine_model.dart';
import '../../../core/services/sync/adapter/generic_sync_adapter.dart';

/// [MedicineSyncAdapter] is responsible for synchronizing [MedicineModel] data between
/// the local database and the remote server. It defines how medicine records are 
/// serialized, deserialized, and uniquely identified for sync operations.

@lazySingleton
class MedicineSyncAdapter extends GenericSyncAdapter<MedicineModel> {
  @override
  String get table => DbTable.medicine(isDefault: true).name;

  @override
  MedicineModel fromJson(Map<String, dynamic> json) =>
      MedicineModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(MedicineModel model) => model.toJson();

  @override
  String getId(MedicineModel model) => model.id;

  @override
  DateTime getUpdatedAt(MedicineModel model) => model.lastUpdated;
}
