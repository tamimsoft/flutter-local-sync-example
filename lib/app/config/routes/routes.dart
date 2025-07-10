import 'package:flutter/material.dart';

import 'routes_name.dart';
import 'views.dart';

/// This class handles the generation of dynamic routes in the application.
/// It uses a private constructor to prevent instantiation and provides
/// a static [generateRoutes] method that returns a [Route] based on the given [RouteSettings].
class Routes {
  Routes._();

  /// Generates a route based on the provided [RouteSettings].
  ///
  /// Takes in [settings] which includes the name of the route.
  /// Returns a [MaterialPageRoute] object that builds the appropriate widget.
  /// If no matching route is found, displays a default screen with a message: 'No route generated'.
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    late Widget widget;

    switch (settings.name) {
      case RouteName.splash:
        widget = StartupGate();
        break;
      case RouteName.permissionDenied:
        widget = PermissionDeniedPage();
        break;
      case RouteName.home:
        widget = MedicinePage();
        break;
      default:
        // If no matching route is found, display a default screen.
        widget = const Scaffold(
          body: Center(child: Text('No route generated')),
        );
    }
    return MaterialPageRoute(builder: (context) => widget);
  }
}
