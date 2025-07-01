import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/medicine_model.dart';
import '../cubit/medicine_cubit.dart';

/// A stateless widget that displays quantity controls and a unit dropdown for a medicine item.
///
/// This widget provides an interface for adjusting the quantity of a medicine using increment
/// and decrement buttons, as well as selecting the packaging type via a dropdown menu.
/// It interacts with the [MedicineCubit] to update the state accordingly.

class QuantityControlsAndUnitDropdown extends StatelessWidget {
  const QuantityControlsAndUnitDropdown({super.key, required this.m});

  /// The medicine model associated with this widget.
  final MedicineModel m;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MedicineCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Quantity Control
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: <Widget>[
              _buildIconButton(
                context: context,
                onTap: () => cubit.decrementQuantity(m.id),
                icon: Icons.remove,
              ),
              BlocBuilder<MedicineCubit, MedicineState>(
                buildWhen: (prev, curr) {
                  final oldItem = prev.medicines.firstWhere(
                    (e) => e.id == m.id,
                  );
                  final newItem = curr.medicines.firstWhere(
                    (e) => e.id == m.id,
                  );
                  return oldItem.quentity != newItem.quentity;
                },
                builder: (context, state) {
                  final updated = state.medicines.firstWhere(
                    (e) => e.id == m.id,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      updated.quentity.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
              _buildIconButton(
                context: context,
                onTap: () => cubit.incrementQuantity(m.id),
                icon: Icons.add,
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // Unit Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: BlocBuilder<MedicineCubit, MedicineState>(
            buildWhen: (prev, curr) {
              final MedicineModel oldItem = prev.medicines.firstWhere(
                (e) => e.id == m.id,
              );
              final MedicineModel newItem = curr.medicines.firstWhere(
                (e) => e.id == m.id,
              );
              return oldItem.packaging != newItem.packaging ||
                  prev.availablePackaging != curr.availablePackaging;
            },
            builder: (context, state) {
              final MedicineModel updated = state.medicines.firstWhere(
                (e) => e.id == m.id,
              );
              return DropdownButtonHideUnderline(
                child: DropdownButton<PackagingType>(
                  isDense: true,
                  value: PackagingType.fromString(updated.packaging),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  items: state.availablePackaging
                      .map<DropdownMenuItem<PackagingType>>(
                        (PackagingType value) {
                          return DropdownMenuItem<PackagingType>(
                            value: value,
                            child: Text(value.name),
                          );
                        },
                      )
                      .toList(),
                  onChanged: (PackagingType? newValue) {
                    if (newValue != null) {
                      cubit.updateSelectedPackage(m.id, newValue);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds an icon button used for adjusting the quantity.
  ///
  /// Takes a [BuildContext], a [VoidCallback] for tap events, and an [IconData] for the icon.
  Widget _buildIconButton({
    required BuildContext context,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
