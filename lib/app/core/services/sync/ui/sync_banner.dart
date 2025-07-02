import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/config/injectable/injection.dart';

import 'cubit/sync_status_cubit.dart';

class SyncBanner extends StatelessWidget {
  SyncBanner({super.key});
  final _cubit = getIt<SyncStatusCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => _cubit, child: _buildUi(context));
  }

  Widget _buildUi(BuildContext context) {
    return BlocBuilder<SyncStatusCubit, SyncStatusState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == SyncStatus.syncing) {
          return _buildBanner(Colors.orange.shade700, '🔁 Syncing...');
        }
        if (state.status == SyncStatus.synced) {
          return _buildBanner(Colors.green.shade600, '🟢 Synced');
        }
        if (state.status == SyncStatus.offline) {
          return _buildBanner(Colors.red.shade600, '🔴 Offline');
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBanner(Color color, String text) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.end,
        style: const TextStyle(
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontSize: 12,
        ),
      ),
    );
  }
}
