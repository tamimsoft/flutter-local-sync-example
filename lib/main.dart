import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import '/app/core/constants/app_strings.dart';

import 'app/app.dart';
import 'app/config/injectable/injection.dart';
import 'app/core/services/database/local/hive_adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure window manager is initialized for desktop applications
  await windowManager.ensureInitialized();
  // Set the application name for the window manager
  WindowOptions windowOptions = WindowOptions(
    size: Size(400, 800),
    minimumSize: Size(400, 600),
    maximumSize: Size(600, 800),
    backgroundColor: Colors.transparent,
    fullScreen: false,
    skipTaskbar: false,
    title: AppStrings.appName,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Initialize Hive for local data persistence
  final dir = await getApplicationDocumentsDirectory();
  Hive.init('${dir.path}/${AppStrings.appName}');

  // Register Hive type adapters for data models
  registerHiveAdapters();

  // Configure dependency injection with development environment
  await configureDependencies(environment: Environment.dev);

  // Launch the main application UI
  runApp(App());
}
