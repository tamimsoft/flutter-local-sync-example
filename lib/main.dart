import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import '/app/app.dart';
import '/app/core/constants/app_strings.dart';
import '/app/config/injectable/injection.dart';
import '/app/core/services/database/local/hive_adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager on desktop platforms
  await _initDesktopWindow();

  // Initialize Hive with app directory
  await _initHive();

  // Setup dependency injection
  await configureDependencies(environment: Environment.dev);

  // Run app
  runApp(const App());
}

Future<void> _initDesktopWindow() async {
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) return;

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
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
}

Future<void> _initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init('${dir.path}/${AppStrings.appName}');
  registerHiveAdapters();
}
