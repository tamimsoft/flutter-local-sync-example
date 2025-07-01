import 'package:flutter/material.dart';

class CustomButtonTheme {
  CustomButtonTheme._();

  static final _commonStyle = ButtonStyle(
    // fixedSize: WidgetStateProperty.all(const Size(double.minPositive, 48)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static ElevatedButtonThemeData get eBTheme =>
      ElevatedButtonThemeData(style: _commonStyle);

  static FilledButtonThemeData get fBTheme =>
      FilledButtonThemeData(style: _commonStyle);

  static OutlinedButtonThemeData get oBTheme =>
      OutlinedButtonThemeData(style: _commonStyle);
}
