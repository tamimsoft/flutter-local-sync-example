import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

/// Utility class for picking images from the camera, gallery, or multiple sources.
@lazySingleton
class ImagePickerUtils {
  final ImagePicker _imagePicker = ImagePicker();

  /// Picks an image from the device's camera.
  ///
  /// Returns the selected image as an [XFile], or null if no image was selected.
  Future<XFile?> pickCameraImage() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    return file;
  }

  /// Picks an image from the device's gallery.
  ///
  /// Returns the selected image as an [XFile], or null if no image was selected.
  Future<XFile?> pickGalleryImage() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return file;
  }

  /// Picks multiple images from the device's gallery.
  ///
  /// Returns a list of selected images as [File] objects.
  Future<List<File>> pickMultipleImages() async {
    // final List<XFile> picked  = await _picker.pickMultiImage(
    //   imageQuality: 80,
    //   maxWidth: 800,
    //   maxHeight: 800,
    // );
    final List<XFile> picked = await _imagePicker.pickMultiImage();
    return picked.map((file) => File(file.path)).toList();
  }
}
