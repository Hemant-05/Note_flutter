import 'package:flutter/material.dart';

bool obscure = true;
Widget cusTextField(String label, TextEditingController controller,
    int? maxLines, Size size, bool autoFocus) {
  bool isPassTF = label.contains('Password');
  return StatefulBuilder(
    builder: (context, currentState) => Container(
      constraints: BoxConstraints(
          maxWidth: size.width * .9, maxHeight: size.height * .08),
      child: TextField(
        obscureText: obscure && isPassTF,
        controller: controller,
        autofocus: autoFocus,
        minLines: null,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(
              color:
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          suffix: isPassTF
              ? IconButton(
            onPressed: () {
              currentState(() {
                obscure = !obscure;
              });
            },
            icon: Icon(obscure
                ? Icons.remove_red_eye
                : Icons.remove_red_eye_outlined),
          )
              : Container(
            width: 2,
            height: 2,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    ),
  );
}