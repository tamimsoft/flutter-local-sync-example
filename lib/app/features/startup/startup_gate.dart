import 'package:flutter/material.dart';
import 'package:instance_a/app/config/routes/routes_name.dart';

import '../../core/utils/sync_storage_manager.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await SyncStorageManager.requestStoragePermission();
    final nextRoute = hasPermission
        ? RouteName.home
        : RouteName.permissionDenied;

    // Delay a bit for transition (optional)
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
