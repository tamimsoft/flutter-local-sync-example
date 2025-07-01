import '/app/core/theme/custom/custom_theme.dart';
import '/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// A class that defines the application's visual theme based on brightness modes.
///
/// [AppTheme] provides pre-defined light and dark themes for the app using
/// Material Design 3 guidelines. It generates a consistent color scheme from
/// a primary seed color and configures common UI components with custom themes.
class AppTheme {
  /// Returns the light theme instance configured with bright mode settings.
  static ThemeData get light => _theme(Brightness.light);

  /// Returns the dark theme instance configured with dark mode settings.
  static ThemeData get dark => _theme(Brightness.dark);

  /// Constructs a theme based on the provided [brightness].
  ///
  /// This method generates a [ThemeData] object with a color scheme derived
  /// from the app's primary color, and applies custom component theming such as
  /// buttons and input decorations.
  static ThemeData _theme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceBright,
      elevatedButtonTheme: CustomButtonTheme.eBTheme,
      filledButtonTheme: CustomButtonTheme.fBTheme,
      outlinedButtonTheme: CustomButtonTheme.oBTheme,
      inputDecorationTheme: brightness == Brightness.light
          ? CustomInputDecorationTheme.light
          : CustomInputDecorationTheme.dark,
    );
  }
}
