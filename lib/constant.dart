import 'package:flutter/material.dart';

Color primaryColor = const Color.fromRGBO(46, 57, 31, 1);
// Color primaryColor = Colors.teal;
Color secondColor = const Color.fromRGBO(58, 72, 40, 1);
// Color secondColor = Colors.tealAccent;

final border = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(50)),
  borderSide: BorderSide(
    width: 1,
    color: primaryColor,
  ),
);

final focusborder = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(50)),
  borderSide: BorderSide(
    width: 2,
    color: primaryColor,
  ),
);

const errorBroder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide:
        BorderSide(width: 2, color: Color.fromARGB(255, 238, 146, 139)));
