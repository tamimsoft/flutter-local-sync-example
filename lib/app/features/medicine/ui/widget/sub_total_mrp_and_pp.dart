import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/medicine_model.dart';
import '../cubit/medicine_cubit.dart';

/// A widget that displays and manages the subtotal, MRP (Maximum Retail Price), and PP (Purchase Price)
/// for a specific medicine item. It allows users to edit MRP and PP values and dynamically updates
/// the subtotal based on quantity and PP.

class SubTotalMrpAndPp extends StatefulWidget {
  const SubTotalMrpAndPp({super.key, required this.m});
  final MedicineModel m;

  @override
  State<SubTotalMrpAndPp> createState() => _SubTotalMrpAndPpState();
}

class _SubTotalMrpAndPpState extends State<SubTotalMrpAndPp> {
  late final TextEditingController _mrpController;
  late final TextEditingController _ppController;

  MedicineCubit get _cubit => context.read<MedicineCubit>();
  @override
  void initState() {
    super.initState();

    final cubit = context.read<MedicineCubit>();
    final initial = cubit.state.medicines.firstWhere(
      (e) => e.id == widget.m.id,
    );

    _mrpController = TextEditingController(
      text: initial.mrp.toStringAsFixed(2),
    );
    _ppController = TextEditingController(text: initial.pp.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _mrpController.dispose();
    _ppController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        BlocBuilder<MedicineCubit, MedicineState>(
          buildWhen: (prev, curr) {
            final oldItem = prev.medicines.firstWhere(
              (e) => e.id == widget.m.id,
            );
            final newItem = curr.medicines.firstWhere(
              (e) => e.id == widget.m.id,
            );
            return oldItem.pp != newItem.pp ||
                oldItem.mrp != newItem.mrp ||
                oldItem.quantity != newItem.quantity;
          },
          builder: (context, state) {
            final updated = state.medicines.firstWhere(
              (e) => e.id == widget.m.id,
            );
            // 🔁 Update controllers only if value is out of sync
            final newMrp = updated.mrp.toStringAsFixed(2);
            final newPp = updated.pp.toStringAsFixed(2);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_mrpController.text != newMrp) {
                _mrpController.text = newMrp;
              }
              if (_ppController.text != newPp) {
                _ppController.text = newPp;
              }
            });

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
          children: [
            _buildTextField(
              labelText: 'MRP ৳',
              controller: _mrpController,
              onTapOutside: (value) {
                _cubit.setMrp(widget.m.id, value);
              },
            ),
            const SizedBox(width: 20),
            _buildTextField(
              labelText: 'PP ৳',
              controller: _ppController,
              onTapOutside: (value) {
                _cubit.setPp(widget.m.id, value);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required Function onTapOutside,
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
              controller: controller,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
                final value = double.tryParse(controller.text);
                if (value != null) {
                  onTapOutside.call(value);
                }
              },
              onFieldSubmitted: (value) {
                FocusScope.of(context).unfocus();
                final parsedValue = double.tryParse(value);
                if (parsedValue != null) {
                  onTapOutside.call(parsedValue);
                }
              },
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
            ),
          ),
        ],
      ),
    );
  }
}
