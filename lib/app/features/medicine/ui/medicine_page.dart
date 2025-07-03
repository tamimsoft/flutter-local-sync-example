import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/services/sync/ui/cubit/sync_status_cubit.dart';
import '/app/core/services/sync/ui/sync_banner.dart';
import '/app/core/constants/app_strings.dart';
import '/app/config/injectable/injection.dart';
import 'cubit/medicine_cubit.dart';
import 'widget/medicine_card.dart';

/// A screen that displays a list of medicines, their calculated total cost,
/// and allows the user to save medicine data.
///
/// This page uses `MedicineCubit` for managing medicine data and
/// `SyncStatusCubit` for synchronization state updates. When synchronized,
/// it automatically refreshes medicine data. The UI includes:
/// - App bar with app name and sync status banner.
/// - List of medicines using [MedicineCard].
/// - Total cost calculation displayed at the bottom.
/// - Save button to persist all medicine data.

class MedicinePage extends StatelessWidget {
  MedicinePage({super.key});

  final cubit = getIt<MedicineCubit>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MedicineCubit>(
          create: (_) {
            cubit.init();
            return cubit;
          },
        ),
        BlocProvider<SyncStatusCubit>(create: (_) => getIt<SyncStatusCubit>()),
      ],
      child: BlocListener<SyncStatusCubit, SyncStatusState>(
        listener: (context, state) {
          if (state.status == SyncStatus.syncing) {
            context.read<MedicineCubit>().refresh();
          }
        },
        child: _buildUi(context),
      ),
    );
  }

  /// Builds the main UI layout for displaying medicines and actions.
  Widget _buildUi(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName),
        actions: [
          // if platform is not android, show sync button
          BlocBuilder<SyncStatusCubit, SyncStatusState>(
            builder: (context, state) {
              if (Theme.of(context).platform != TargetPlatform.android &&
                  state.status == SyncStatus.synced) {
                return IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: () async {
                    await cubit.refresh();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SyncBanner(),
          ),
        ],
      ),
      body: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, state) {
          double total = state.medicines.fold(
            0,
            (sum, m) => sum + (m.quantity * m.pp),
          );
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<MedicineCubit>().refresh();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.medicines.length,
                    itemBuilder: (context, index) {
                      final m = state.medicines[index];
                      return MedicineCard(m: m);
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Total: ${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicineCubit>().saveAll();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data saved')),
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
