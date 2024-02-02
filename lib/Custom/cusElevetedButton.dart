import 'package:flutter/material.dart';

int imp = 0;
bool isLoading = false;

cusElevatedButton(
  BuildContext context,
  String text,
  fun(),
  Size size,
) {
  return ElevatedButton(
    onPressed: fun,
    style: ElevatedButton.styleFrom(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Colors.grey[600]
              : Colors.grey,
      minimumSize: Size(size.width * .9, size.height * .075),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    child: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Text(
            '$text',
            style: TextStyle(
                fontSize: size.height * .035,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
  );
}
