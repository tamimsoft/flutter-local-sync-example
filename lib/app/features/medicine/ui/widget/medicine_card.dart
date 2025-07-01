import 'package:flutter/material.dart';

import '../../data/model/medicine_model.dart';
import 'image_and_name.dart';
import 'quantity_controls_and_unit_dropdown.dart';
import 'sub_total_mrp_and_pp.dart';

/// A widget representing a medicine card in the UI.
///
/// Displays medicine details such as image, name, quantity controls,
/// unit dropdown, and pricing information (MRP, PP, Sub Total).
/// Designed to be used in lists or grids for viewing medicines.
class MedicineCard extends StatelessWidget {
  /// Creates a [MedicineCard] with the given [MedicineModel].
  ///
  /// [m] must not be null and contains the medicine data to display.
  const MedicineCard({super.key, required this.m});

  /// The medicine model containing data to be displayed.
  final MedicineModel m;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left section: Image and Name
                Expanded(child: ImageAndName(m: m)),
                // Right section: Sub Total, MRP, PP
                Expanded(child: SubTotalMrpAndPp(m: m)),
              ],
            ),
            const SizedBox(height: 16),
            // Bottom section: Quantity controls and Unit dropdown
            QuantityControlsAndUnitDropdown(m: m),
          ],
        ),
      ),
    );
  }
}
