part of 'medicine_cubit.dart';

/// Represents the type of packaging for a medicine.
enum PackagingType {
  piece('Piece'),
  packs('Packs'),
  box('Box');

  /// The human-readable name of the packaging type.
  final String name;

  const PackagingType(this.name);

  /// Factory method to get a [PackagingType] from a string.
  factory PackagingType.fromString(String value) {
    return PackagingType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PackagingType.piece,
    );
  }

  @override
  String toString() => name;
}

/// State class representing the UI state for medicine-related operations.
///
/// Contains list of medicines, selected quantity, available packaging types,
/// loading status, and potential error messages.
@freezed
class MedicineState with _$MedicineState {
  const factory MedicineState({
    /// List of available medicines.
    @Default([]) List<MedicineModel> medicines,

    /// Current selected quantity of medicine.
    @Default(1) int quantity,

    /// Available packaging options.
    @Default(PackagingType.values) List<PackagingType> availablePackaging,

    /// Indicates if data is currently being loaded.
    @Default(false) bool isLoading,

    /// Optional error message in case of failure.
    String? errorMessage,
  }) = _MedicineState;
}
