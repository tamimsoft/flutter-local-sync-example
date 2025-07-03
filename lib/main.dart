import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '/app/core/constants/app_strings.dart';

import 'app/app.dart';
import 'app/config/injectable/injection.dart';
import 'app/core/services/database/local/hive_adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local data persistence
  Hive.initFlutter(AppStrings.appName);

  // Register Hive type adapters for data models
  registerHiveAdapters();

  // Configure dependency injection with development environment
  await configureDependencies(environment: Environment.dev);

  // Launch the main application UI
  runApp(App());
}
