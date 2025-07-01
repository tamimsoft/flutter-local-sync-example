import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '/app/core/services/sync/service/sync_watcher_service.dart';
import '/app/core/utils/shared_file_util.dart';
import '/app/core/utils/image_picker_utils.dart';
import '/app/features/medicine/data/model/medicine_model.dart';
import '/app/features/medicine/data/repository/medicine_repository.dart';
import '/app/core/services/database/app_db.dart';

import '../../service/medicine_service.dart';
part 'medicine_state.dart';
part 'medicine_cubit.freezed.dart';

/// Manages medicine-related business logic and state for the application.
///
/// This Cubit handles initialization, data synchronization, user interactions,
/// and image management for medicines. It communicates with the repository,
/// manages local state updates, and watches for database changes to keep UI in sync.
@injectable
class MedicineCubit extends Cubit<MedicineState> {
  final MedicineRepository _repo;
  final MedicineService _service;
  final ImagePickerUtils _imagePicker;
  final SyncWatcherService _watcher;

  /// Constructs a [MedicineCubit] with required dependencies.
  ///
  /// - [_repo]: Repository handling medicine data operations.
  /// - [_service]: Service providing utility functions like dummy data generation.
  /// - [_imagePicker]: Utility to pick images from device gallery.
  /// - [_watcher]: Watches database changes and triggers updates.
  MedicineCubit(this._repo, this._service, this._imagePicker, this._watcher)
    : super(MedicineState());

  /// Initializes medicine data on app start.
  ///
  /// - Syncs remote data if available.
  /// - Loads existing data or generates dummy data if empty.
  /// - Saves asset images locally and updates their paths.
  /// - Starts watching database changes to maintain real-time sync.
  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repo.sync();
      final existing = await _repo.getAll();

      if (existing.isEmpty) {
        final dummyData = _service.generateDummyData();

        // Save asset images to local storage
        // and update the image paths in the dummy data
        final updatedDummyData = await Future.wait(
          dummyData.map((m) async {
            String? imagePath;
            if (m.imagePath != null) {
              imagePath = await _saveAssetImageToLocal(
                m.imagePath!,
              ); // await here
            }
            return m.copyWith(imagePath: imagePath);
          }),
        );

        emit(state.copyWith(medicines: updatedDummyData, isLoading: false));
        await _repo.saveAll(updatedDummyData);
      } else {
        emit(state.copyWith(medicines: existing, isLoading: false));
      }
      _watcher.init(onChange: _onFileChanged);
      _watcher.startWatching(DbTable.medicine(isDefault: true).name);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Callback triggered when watched database table changes.
  ///
  /// Updates medicine list in the state to reflect latest database content.
  Future<void> _onFileChanged(String table) async {
    if (table == DbTable.medicine(isDefault: true).name) {
      final data = await _repo.getAll();
      emit(state.copyWith(medicines: data));
    }
  }

  /// Simulates manual refresh of medicine list.
  ///
  /// Used to demonstrate loading behavior and fetch latest data from repository.
  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate delay
      final data = await _repo.getAll();
      emit(state.copyWith(medicines: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Updates a specific medicine entry in both state and persistence.
  ///
  /// Automatically sets [lastUpdated] timestamp upon successful update.
  Future<void> updateMedicine(MedicineModel updated) async {
    try {
      final updatedList = state.medicines
          .map(
            (m) => m.id == updated.id
                ? updated.copyWith(lastUpdated: DateTime.now())
                : m,
          )
          .toList();
      emit(state.copyWith(medicines: updatedList));
      _repo.save(updated);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Persists all current medicines to repository.
  ///
  /// Useful for bulk saving after multiple local edits.
  Future<void> saveAll() async => _repo.saveAll(state.medicines);

  /// Increases quantity of selected medicine by one.
  void incrementQuantity(String mId) {
    final updatedList = state.medicines.map((m) {
      if (m.id == mId) {
        return m.copyWith(quentity: m.quentity + 1);
      }
      return m;
    }).toList();

    emit(state.copyWith(medicines: updatedList));
  }

  /// Decreases quantity of selected medicine by one (minimum 1).
  void decrementQuantity(String mId) {
    final updatedList = state.medicines.map((m) {
      if (m.id == mId && m.quentity > 1) {
        return m.copyWith(quentity: m.quentity - 1);
      }
      return m;
    }).toList();

    emit(state.copyWith(medicines: updatedList));
  }

  /// Updates packaging type of selected medicine.
  void updateSelectedPackage(String mId, PackagingType? packaging) {
    final updatedList = state.medicines.map((m) {
      if (m.id == mId && packaging != null) {
        return m.copyWith(packaging: packaging.name);
      }
      return m;
    }).toList();

    emit(state.copyWith(medicines: updatedList));
  }

  /// Sets Maximum Retail Price (MRP) for selected medicine.
  void setMrp(String mId, double newMrp) {
    final updatedList = state.medicines.map((m) {
      if (m.id == mId) {
        return m.copyWith(mrp: newMrp);
      }
      return m;
    }).toList();

    emit(state.copyWith(medicines: updatedList));
  }

  /// Sets purchase price (PP) for selected medicine.
  void setPp(String mId, double newPp) {
    final updatedList = state.medicines.map((m) {
      if (m.id == mId) {
        return m.copyWith(pp: newPp);
      }
      return m;
    }).toList();

    emit(state.copyWith(medicines: updatedList));
  }

  /// Picks an image from gallery and associates it with selected medicine.
  void pickImage(String mId) async {
    final XFile? picked = await _imagePicker.pickGalleryImage();
    if (picked != null) {
      final String? savedImagePath = await _saveImageToLocal(File(picked.path));

      final updatedList = state.medicines.map((m) {
        if (m.id == mId && savedImagePath != null) {
          return m.copyWith(imagePath: savedImagePath);
        }
        return m;
      }).toList();

      emit(state.copyWith(medicines: updatedList));
    }
  }

  /// Removes associated image from selected medicine.
  void removeImage(String mId) async {
    final updatedList = state.medicines.map((m) {
      if (m.id == mId) {
        return m.copyWith(imagePath: null);
      }
      return m;
    }).toList();
    emit(state.copyWith(medicines: updatedList));
  }

  /// Saves provided image file to local shared directory.
  ///
  /// Returns path to saved image or null if failed.
  Future<String?> _saveImageToLocal(File imageFile) async {
    final dir = await SyncStorageManager.getSharedDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = '${dir.path}/$fileName.png';
    final newImage = await imageFile.copy(path);
    return newImage.path;
  }

  /// Saves asset-based image to local shared directory.
  ///
  /// Converts asset bytes into physical file and returns its path.
  Future<String?> _saveAssetImageToLocal(String assetPath) async {
    try {
      final byteData = await rootBundle.load(
        assetPath,
      ); // Load bytes from asset
      final dir = await SyncStorageManager.getSharedDirectory();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = '${dir.path}/$fileName.png';

      final file = File(path);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file.path;
    } catch (e) {
      debugPrint('❌ Failed to save asset image: $e');
      return null;
    }
  }

  /// Stops watching database before closing the cubit.
  @override
  Future<void> close() {
    _watcher.stopWatching(DbTable.medicine(isDefault: true).name);
    return super.close();
  }
}
