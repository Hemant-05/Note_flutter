import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:note/Provider/NoteProvider.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:note/Screens/HomeScreen.dart';

int imp = 0;

ButtonStyle style() {
  return const ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.black),
  );
}
showCusDeleteDialog(
    BuildContext context,Note note, bool inDetail, NoteProvider value) {
  showDialog(
    context: context,
    builder: (context) {
      int? id = note.id;
      String caution = note.imp == 1? 'This is an Important note are you sure to delete it ?': 'Delete';
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          icon: Icon(
            note.imp == 1? Icons.report_problem_outlined : Icons.delete_forever_outlined,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            size: 40,
          ),
          title: Text('$caution'),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              style: style(),
              onPressed: () {
                showCusSnackBar(context, 'Note Deleted !');
                Navigator.pop(context);
              },
              child: Transform.rotate(
                angle: 40,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            ElevatedButton(
              style: style(),
              onPressed: () async {
                int c = await value.deleteNote(id!);
                if (c != 0) {
                  showCusSnackBar(context, 'Deleted Successfully....');
                } else {
                  showCusSnackBar(context, 'Some Error !!');
                }
                if (!inDetail) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false);
                }
              },
              child: const Icon(
                Icons.done,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget hGap(double x) {
  return SizedBox(height: x);
}

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

cusElevatedButton(BuildContext context, String text, fun(), Size size) {
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
    child: Text(
      '$text',
      style: TextStyle(
          fontSize: size.height * .035 , color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

showCusSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$text'),
    ),
  );
}

Widget cusText(String text, double size, bool isBold) {
  return Text(
    '$text',
    style: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
        fontSize: size),
  );
}
