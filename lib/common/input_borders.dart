import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

final border = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(50)),
  borderSide: BorderSide(
    width: 1,
    color: AppColors.primaryColor,
  ),
);

final focusborder = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(50)),
  borderSide: BorderSide(
    width: 2,
    color: AppColors.primaryColor,
  ),
);

const errorBroder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide:
        BorderSide(width: 2, color: Color.fromARGB(255, 238, 146, 139)));
