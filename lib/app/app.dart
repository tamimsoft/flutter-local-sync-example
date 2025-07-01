import 'package:flutter/material.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';

/// The main entry point of the application.
///
/// This widget sets up the core configuration for the app, including the title,
/// theme, routing, and initial screen. It uses [MaterialApp] to provide a rich 
/// Material Design experience.
class App extends StatelessWidget {
  /// Creates a new instance of the [App] widget.
  ///
  /// The constructor is marked as `const` to allow compile-time instantiation
  /// where possible, improving performance.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// Sets the application name shown in the app drawer and other system UIs.
      title: AppStrings.appName,

      /// Applies the light theme defined in the app's design system.
      theme: AppTheme.light,

      /// Debugging feature to hide the "DEBUG" banner in development mode.
      debugShowCheckedModeBanner: false,

      /// Generates routes dynamically using the [Routes] class.
      onGenerateRoute: Routes.generateRoutes,

      /// Sets the initial route to the review page.
      initialRoute: RouteName.review,
    );
  }
}
