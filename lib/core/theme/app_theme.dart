import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Poppins",
    colorSchemeSeed: AppColors.primaryColor,
    brightness: Brightness.light,
    useMaterial3: true,
  );
}
