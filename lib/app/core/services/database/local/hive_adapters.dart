import 'package:hive/hive.dart';
import '/app/features/medicine/data/model/medicine_model.dart';

/// A list of Hive adapters with their associated type IDs.
///
/// Each tuple consists of:
/// - [id]: The unique type ID for the adapter.
/// - [adapter]: The Hive adapter instance.
final hiveAdapters = [
  (id: 0, adapter: MedicineModelAdapter()),
  // (id: 1, adapter: UserModelAdapter()),
  // (id: 2, adapter: OrderModelAdapter()),
];

/// Registers all Hive adapters listed in [hiveAdapters].
///
/// This function iterates through the [hiveAdapters] list and registers each
/// adapter only if it has not already been registered with Hive.
void registerHiveAdapters() {
  for (var item in hiveAdapters) {
    if (!Hive.isAdapterRegistered(item.id)) {
      Hive.registerAdapter(item.adapter);
    }
  }
}
