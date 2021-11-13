import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(IconData icon, Color color) {
  return InputDecoration(
    prefixIcon: Icon(
      icon,
      color: color,
    ),
    contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
  );
}
