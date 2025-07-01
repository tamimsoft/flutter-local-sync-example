import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomInputDecorationTheme {
  CustomInputDecorationTheme._();

  static InputDecorationTheme light = _baseTheme(
    borderColor: Colors.grey.shade400,
    floatingLabelColor: AppColors.primary,
  );

  static InputDecorationTheme dark = _baseTheme(
    borderColor: Colors.grey.shade600,
    floatingLabelColor: AppColors.primary,
  );

  static InputDecorationTheme _baseTheme({
    required Color borderColor,
    required Color floatingLabelColor,
  }) {
    return InputDecorationTheme(
      labelStyle: const TextStyle(fontWeight: FontWeight.w300),
      floatingLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: floatingLabelColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: floatingLabelColor, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: borderColor),
      ),
    );
  }
}
