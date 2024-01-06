import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/Custom/custom_item.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/Resources/Colors.dart';
import 'package:note/Resources/NoteModel.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({required this.note, super.key});

  final Note note;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  TextEditingController contentCon = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contentCon.text = widget.note.content;
  }

  Widget delete() {
    return IconButton(
      onPressed: () {
        showCusDeleteDialog(context, widget.note.id,true);
      },
      icon: Icon(
        Icons.delete_forever_outlined,
        color: textColor,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          CusAppBar(context, size.width, size.height * 0.18,
              '${widget.note.title}', '${widget.note.time}', delete(),false),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: contentCon,
                decoration: const InputDecoration(border: InputBorder.none),
                style: TextStyle(color: textColor, fontSize: 20),
                maxLines: 1000,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Update',
        onPressed: () async {
          Note old = widget.note;
          String content = contentCon.text.toString().trim();
          DateTime now = DateTime.now();
          String time = DateFormat.jm().format(now);
          String date = DateFormat('dd-MM-yyyy').format(now);
          Note note = Note(
              id: old.id,
              title: old.title,
              content: content,
              date: date,
              time: time);
          int c = await DatabaseHelper().updateNote(note);
          Navigator.pop(context);
          if (c != 0) {
            showCusSnackBar(context, 'Updated Successfully');
          } else {
            showCusSnackBar(context, 'Some Error!');
          }
        },
        child: Icon(Icons.save_as_sharp),
      ),
    );
  }
}
