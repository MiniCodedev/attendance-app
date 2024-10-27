import 'package:attendanceapp/common/input_borders.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      errorBorder: errorBroder,
      border: border,
      enabledBorder: border,
      focusedBorder: focusborder,
    ),
    fontFamily: "Poppins",
    colorSchemeSeed: AppColors.primaryColor,
    brightness: Brightness.light,
    useMaterial3: true,
  );
}
