import 'package:injectable/injectable.dart';
import 'package:instance_a/app/core/constants/image_path.dart';

import '../data/model/medicine_model.dart';
import '../ui/cubit/medicine_cubit.dart';

@injectable
class MedicineService {
  List<MedicineModel> generateDummyData() {
    final now = DateTime.now();
    // Generate dummy allopathic medicines
    return [
      MedicineModel(
        id: '1',
        name: 'Napa Extra',
        quentity: 12,
        packaging: PackagingType.packs.name,
        mrp: 30,
        pp: 18,
        imagePath: ImagePath.napaExtra,
        lastUpdated: now,
      ),
      MedicineModel(
        id: '2',
        name: 'Amodis',
        quentity: 10,
        packaging: PackagingType.packs.name,
        mrp: 17,
        pp: 10,
        imagePath: ImagePath.amodis,
        lastUpdated: now,
      ),
      MedicineModel(
        id: '3',
        name: 'Maxpro',
        quentity: 10,
        packaging: PackagingType.box.name,
        mrp: 540,
        pp: 350,
        imagePath: ImagePath.maxPro,
        lastUpdated: now,
      ),
      MedicineModel(
        id: '4',
        name: 'Algin',
        quentity: 10,
        packaging: PackagingType.box.name,
        mrp: 850,
        pp: 520,
        imagePath: ImagePath.algin,
        lastUpdated: now,
      ),
      MedicineModel(
        id: '5',
        name: 'Esoral',
        quentity: 8,
        packaging: PackagingType.packs.name,
        mrp: 84,
        pp: 40,
        imagePath: ImagePath.esoral,
        lastUpdated: now,
      ),
    ];
  }
}
