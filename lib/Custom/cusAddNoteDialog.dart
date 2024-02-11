import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/Custom/cusHeightGap.dart';
import 'package:note/Custom/cusSwipableButton.dart';
import 'package:note/Custom/cusTextField.dart';
import 'package:note/Provider/NoteProvider.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:note/Resources/Utils.dart';

import 'cusSnackBar.dart';

class AddNote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int imp = 0;
  TextEditingController titleCon = TextEditingController();
  TextEditingController contentCon = TextEditingController();

  showCusAddNoteDialog(BuildContext context, NoteProvider value) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Dialog(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 330),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxHeight: 70),
                      child: cusTextField(
                        'Enter Title',
                        titleCon,
                        1,
                        size,
                        true,
                      ),
                    ),
                    hGap(14),
                    Expanded(
                      child: cusTextField(
                        'Write your note here....',
                        contentCon,
                        null,
                        size,
                        true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Important ?',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Switch(
                          trackColor: MaterialStatePropertyAll(imp == 1
                              ? Colors.red
                              : MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white),
                          trackOutlineWidth: MaterialStatePropertyAll(2),
                          value: imp == 1,
                          onChanged: (value) {
                            setState(() {
                              imp = value ? 1 : 0;
                            });
                          },
                        ),
                      ],
                    ),
                    cusSwipeableButton(context, () => addNote(context, value),
                        'Slide to Save', true),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void addNote(BuildContext context, NoteProvider value) async {
    var title = titleCon.text.toString();
    var content = contentCon.text.toString();
    DateTime now = DateTime.now();
    String time = DateFormat.jm().format(now);
    String date = DateFormat('dd-MM-yyyy').format(now);
    if (!title.isEmpty) {
      Note note = Note(
        title: '$title',
        content: '$content',
        date: '$date',
        time: '$time',
        imp: imp,
      );
      await value.insertNote(note);
      _firestore
          .collection('users')
          .doc(user?.uid)
          .collection('notes')
          .doc('${note.title + note.time}')
          .set(note.toJson());
      imp = 0;
      Navigator.pop(context);
    } else {
      showCusSnackBar(context, 'Write something');
      Navigator.pop(context);
    }
  }
}
