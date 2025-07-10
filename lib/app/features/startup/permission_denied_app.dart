import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/routes/routes_name.dart';
import '../../core/utils/sync_storage_manager.dart';

class PermissionDeniedPage extends StatefulWidget {
  const PermissionDeniedPage({super.key});

  @override
  State<PermissionDeniedPage> createState() => _PermissionDeniedPageState();
}

class _PermissionDeniedPageState extends State<PermissionDeniedPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _isRequesting = false;

  Future<void> _retryPermission() async {
    setState(() => _isRequesting = true);

    final hasPermission = await SyncStorageManager.requestStoragePermission();

    if (hasPermission && mounted) {
      Navigator.pushReplacementNamed(
        context,
        RouteName.home,
      ); // Redirect to home
    } else {
      setState(() => _isRequesting = false);

      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Permission still denied. Please allow from settings.'),
        ),
      );
    }
  }

  void _openAppSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      title: 'Permission Required',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  "Storage permission is required to use this app.\n"
                  "Please grant permission to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isRequesting ? null : _retryPermission,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry Permission"),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _openAppSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text("Open App Settings"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
