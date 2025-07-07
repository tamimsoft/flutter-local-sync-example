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

  final MedicineModel m;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MedicineCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        BlocBuilder<MedicineCubit, MedicineState>(
          buildWhen: (prev, curr) {
            final oldItem = prev.medicines.firstWhere((e) => e.id == m.id);
            final newItem = curr.medicines.firstWhere((e) => e.id == m.id);
            return oldItem.pp != newItem.pp ||
                oldItem.quantity != newItem.quantity;
          },
          builder: (context, state) {
            final updated = state.medicines.firstWhere((e) => e.id == m.id);
            final subTotal = updated.quantity * updated.pp;
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
        Row(
          children: <Widget>[
            BlocBuilder<MedicineCubit, MedicineState>(
              buildWhen: (prev, curr) {
                final oldItem = prev.medicines.firstWhere((e) => e.id == m.id);
                final newItem = curr.medicines.firstWhere((e) => e.id == m.id);
                return oldItem.mrp != newItem.mrp;
              },
              builder: (context, state) {
                final updated = state.medicines.firstWhere((e) => e.id == m.id);
                return _buildTextField(
                  labelText: 'MRP ৳',
                  value: updated.mrp.toStringAsFixed(2),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    cubit.setMrp(updated.id, parsed ?? 0.0);
                  },
                );
              },
            ),
            const SizedBox(width: 20),
            BlocBuilder<MedicineCubit, MedicineState>(
              buildWhen: (prev, curr) {
                final oldItem = prev.medicines.firstWhere((e) => e.id == m.id);
                final newItem = curr.medicines.firstWhere((e) => e.id == m.id);
                return oldItem.pp != newItem.pp;
              },
              builder: (context, state) {
                final updated = state.medicines.firstWhere((e) => e.id == m.id);
                return _buildTextField(
                  labelText: 'PP ৳',
                  value: updated.pp.toStringAsFixed(2),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    cubit.setPp(updated.id, parsed ?? 0.0);
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String labelText,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            labelText,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: value,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
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
