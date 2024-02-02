import 'package:flutter/material.dart';

Widget cusText(String text, double size, bool isBold) {
  return Text(
    '$text',
    style: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
        fontSize: size),
  );
}
