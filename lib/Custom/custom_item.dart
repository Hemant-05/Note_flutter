import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/Resources/NoteModel.dart';

showNewCusDialog(BuildContext context) {
  TextEditingController titleCon = TextEditingController();
  TextEditingController contentCon = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              cusTextField('Enter Title', titleCon),
              hGap(12),
              cusTextField('Write your note here....', contentCon),
              hGap(12),
              ElevatedButton(
                  onPressed: () async {
                    var time = DateTime.timestamp();
                    var date = DateTime.now();
                    var title = titleCon.text.toString();
                    var content = contentCon.text.toString();
                    if (!title.isEmpty) {
                      Note note = Note(
                          title: '$title',
                          content: '$content',
                          date: '$date',
                          time: '$time');
                      int a = await DatabaseHelper().insertNote(note);
                      print('$a');
                      Navigator.pop(context);
                    } else {
                      showCusSnackBar(context, 'Write something');
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'))
            ],
          ),
        ),
      );
    },
  );
}

showCusDeleteDialog(BuildContext context, int? id) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Icon(Icons.delete_forever_outlined),
        title: Text('Delete'),
        actions: [
          ElevatedButton(
              onPressed: () {
                showCusSnackBar(context, 'Note Deleted !');
                Navigator.pop(context);
              },
              child: Icon(Icons.add)),
          ElevatedButton(
              onPressed: () async {
                int c = await DatabaseHelper().deleteNote(id!);
                if(c != 0){
                  showCusSnackBar(context, 'Deleted Successfully....');
                }else{
                  showCusSnackBar(context,'Some Error !!');
                }
                Navigator.pop(context);
              },
              child: Icon(
                Icons.done,
              )),
        ],
      );
    },
  );
}

Widget hGap(double x) {
  return SizedBox(height: x);
}

Widget cusTextField(String label, TextEditingController controller) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 400),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(
          label,
          style: TextStyle(color: Colors.black45),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    ),
  );
}

showCusSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('$text'),
  ));
}
