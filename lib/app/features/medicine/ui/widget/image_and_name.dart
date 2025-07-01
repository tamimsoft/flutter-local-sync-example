import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/features/medicine/ui/cubit/medicine_cubit.dart';

import '../../data/model/medicine_model.dart';

/// A StatelessWidget representing a medicine item with its image and name.
///
/// Displays either the uploaded image or an upload placeholder, along with
/// the medicine's name. Allows interaction for uploading/removing images.
class ImageAndName extends StatelessWidget {
  /// Constructs an [ImageAndName] widget.
  ///
  /// Requires a valid [MedicineModel] object to display data.
  const ImageAndName({super.key, required this.m});

  /// The medicine model containing data (like name and image path).
  final MedicineModel m;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MedicineCubit>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BlocBuilder<MedicineCubit, MedicineState>(
          builder: (context, state) {
            // Check if the image exists and display it
            if (m.imagePath != null && File(m.imagePath!).existsSync()) {
              return _buildImage(m, cubit);
            }
            // Display upload placeholder if no image is found
            return InkWell(
              onTap: () => cubit.pickImage(m.id),
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file_outlined),
                    Text(
                      'Upload\nImage',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            m.name,
            maxLines: 1,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the image widget based on the provided [MedicineModel].
  ///
  /// Returns a [Stack] containing the image and a close icon to remove it.
  Widget _buildImage(MedicineModel m, cubit) {
    final String path = m.imagePath!;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: path.startsWith('assets/')
              ? Image.asset(path, width: 60, height: 80, fit: BoxFit.cover)
              : Image.file(
                  File(m.imagePath!),
                  width: 60,
                  height: 80,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () => cubit.removeImage(m.id),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(12),
                ),
                color: Colors.red.withAlpha(150),
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
