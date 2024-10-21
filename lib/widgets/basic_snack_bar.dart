import 'package:flutter/material.dart';

showSnackBar(context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    action: SnackBarAction(
      label: "Ok",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}
