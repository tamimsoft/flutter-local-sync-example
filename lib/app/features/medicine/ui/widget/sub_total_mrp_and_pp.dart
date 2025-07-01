import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/medicine_model.dart';
import '../cubit/medicine_cubit.dart';

/// A widget that displays and manages the subtotal, MRP (Maximum Retail Price), and PP (Purchase Price)
/// for a specific medicine item. It allows users to edit MRP and PP values and dynamically updates
/// the subtotal based on quantity and PP.

class SubTotalMrpAndPp extends StatelessWidget {
  const SubTotalMrpAndPp({super.key, required this.m});

  /// The medicine model associated with this widget.
  final MedicineModel m;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MedicineCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        /// Watches changes in medicine quantity or PP to update the subtotal.
        BlocBuilder<MedicineCubit, MedicineState>(
          buildWhen: (prev, curr) {
            final oldItem = prev.medicines.firstWhere((e) => e.id == m.id);
            final newItem = curr.medicines.firstWhere((e) => e.id == m.id);
            return oldItem.quentity != newItem.quentity ||
                oldItem.pp != newItem.pp;
          },
          builder: (context, state) {
            final updated = state.medicines.firstWhere((e) => e.id == m.id);
            final double subTotal = updated.quentity * updated.pp;
            return Text(
              'Sub Total: ৳ ${subTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        /// Fields to edit MRP and PP values for the medicine item.
        Row(
          children: <Widget>[
            _buildTextField(
              labelText: 'MRP ৳',
              initialValue: m.mrp.toStringAsFixed(2),
              onChanged: (value) {
                final parsed = double.tryParse(value);
                cubit.setMrp(m.id, parsed ?? 0.0);
              },
            ),
            const SizedBox(width: 20),
            _buildTextField(
              labelText: 'PP ৳',
              initialValue: m.pp.toStringAsFixed(2),
              onChanged: (value) {
                final parsed = double.tryParse(value);
                cubit.setPp(m.id, parsed ?? 0.0);
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a text field for editing numerical values like MRP or PP.
  Widget _buildTextField({
    required String labelText,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            labelText,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: initialValue,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
              ],
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
