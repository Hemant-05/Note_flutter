import 'package:flutter/material.dart';

showCusSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$text'),
    ),
  );
}
