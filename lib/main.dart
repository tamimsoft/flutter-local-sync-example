import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'app/app.dart';
import 'app/config/injectable/injection.dart';
import 'app/core/services/database/local/hive_adapters.dart';
import 'app/core/services/sync/scheduler/sync_scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local data persistence
  Hive.initFlutter();

  // Register Hive type adapters for data models
  registerHiveAdapters();

  // Configure dependency injection with development environment
  await configureDependencies(environment: Environment.dev);

  // Start background synchronization scheduler
  getIt<SyncScheduler>().start();

  // Launch the main application UI
  runApp(App());
}
