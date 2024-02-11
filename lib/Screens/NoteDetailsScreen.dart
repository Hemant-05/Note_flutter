import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/Custom/cusSnackBar.dart';
import 'package:note/Custom/cusText.dart';
import 'package:note/Provider/NoteProvider.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:provider/provider.dart';
import '../Custom/cusDeleteDialog.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({required this.note, super.key});

  final Note note;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  TextEditingController contentCon = TextEditingController();
  TextEditingController titleController = TextEditingController();
  int imp = 0;

  @override
  Widget build(BuildContext context) {
    return  Consumer<NoteProvider>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(border: InputBorder.none),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            actions: [delete(value)],
          ),
          body: PopScope(
            canPop: true,
            onPopInvoked: (s) {
              updateNote(value);
            },
            child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: cusText(
                          ' ${widget.note.time}\n ${widget.note.date}', 14, true,
                      ),
                    ),
                    Container(
                      width: 80,
                    ),
                    const Text(
                      'Important ? ',
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
                      trackOutlineWidth: const MaterialStatePropertyAll(2),
                      value: imp == 1,
                      onChanged: (value) {
                        setState(() {
                          imp = value ? 1 : 0;
                        });
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  child: TextField(
                    controller: contentCon,
                    autofocus: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(fontSize: 20),
                    maxLines: 1000,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    contentCon.text = widget.note.content;
    titleController.text = widget.note.title;
    imp = widget.note.imp;
  }

  void updateNote(NoteProvider value) async {
    Note old = widget.note;
    String title = titleController.text.toString().trim();
    String content = contentCon.text.toString().trim();
    bool isUpdate = title == (old.title) && content == (old.content) && imp == old.imp;
    if(!isUpdate){
      DateTime now = DateTime.now();
      String time = DateFormat.jm().format(now);
      String date = DateFormat('dd-MM-yyyy').format(now);
      Note note = Note(
        id: old.id,
        title: title,
        content: content,
        date: date,
        time: time,
        imp: imp,
      );
      await value.updateNote(note);
    }
  }

  Widget delete(NoteProvider value) {
    return IconButton(
      onPressed: () {
        showCusDeleteDialog(context, widget.note, true, value);
      },
      icon: const Icon(
        Icons.delete_forever_outlined,
        size: 30,
      ),
    );
  }
}
