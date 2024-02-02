import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:note/Custom/cusSnackBar.dart';
import 'package:note/Provider/NoteProvider.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:note/Screens/HomeScreen.dart';
import 'cusButtonStyle.dart';

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
