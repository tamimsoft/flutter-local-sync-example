import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomTextButtonTheme {
  CustomTextButtonTheme._();

  static TextButtonThemeData get light {
    return TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    );
  }

  static TextButtonThemeData get dark {
    return TextButtonThemeData(
      // style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    );
  }
}
