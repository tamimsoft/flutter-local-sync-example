import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'medicine_model.freezed.dart';

part 'medicine_model.g.dart';

/// Represents a medicine entity with essential details for storage and management.
/// This model is used to persist medicine data locally using Hive.
@freezed
@HiveType(typeId: 0)
class MedicineModel with _$MedicineModel {
  const factory MedicineModel({
    /// Unique identifier for the medicine
    @HiveField(0) required String id,

    /// Name of the medicine
    @HiveField(1) required String name,

    /// Quantity available in stock
    @HiveField(2) required int quentity,

    /// Packaging information (e.g., "Pcs, Packs, Box")
    @HiveField(3) required String packaging,

    /// Maximum Retail Price
    @HiveField(4) required double mrp,

    /// Purchase price of the medicine
    @HiveField(5) required double pp,

    /// Optional path to the medicine's image asset
    @HiveField(6) required String? imagePath,

    /// Timestamp indicating when the medicine info was last updated
    @HiveField(7) required DateTime lastUpdated,
  }) = _MedicineModel;

  /// Converts a JSON map to a [MedicineModel] instance.
  factory MedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelFromJson(json);
}
