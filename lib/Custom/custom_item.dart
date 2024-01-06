import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/Resources/Colors.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:note/Screens/HomeScreen.dart';

Widget CusAppBar(BuildContext context, double wi,double hi, String title,String time,Widget widget,bool isSearch) {
  return Container(
    width: wi,
    height: hi,
    alignment: Alignment.bottomCenter,
    decoration: BoxDecoration(
      color: AppBarColor,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
    child: Container(
      constraints: BoxConstraints(maxWidth: wi * .85),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: !isSearch,
                child: CusText(
                  title,
                  40,
                  true
                ),
              ),
              Visibility(
                visible: !(title == 'Notes'),
                child: CusText(
                  'Last Updated $time',
                  16,
                  true
                ),
              ),
            ],
          ),
          widget,
        ],
      ),
    ),
  );
}

showCusAddNoteDialog(BuildContext context) {
  TextEditingController titleCon = TextEditingController();
  TextEditingController contentCon = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          constraints: BoxConstraints(maxHeight: 260),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              cusTextField('Enter Title', titleCon),
              hGap(12),
              cusTextField('Write your note here....', contentCon),
              hGap(12),
              ElevatedButton(
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    String time = DateFormat.jm().format(now);
                    String date = DateFormat('dd-MM-yyyy').format(now);
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

showCusDeleteDialog(BuildContext context, int? id,bool inDetail) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Icon(Icons.delete_forever_outlined,size: 40,color: Colors.red,),
        title: Text('Delete'),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
              onPressed: () {
                showCusSnackBar(context, 'Note Deleted !');
                    Navigator.pop(context);
              },
              child: Transform.rotate(
                angle: 40,
                  child: Icon(Icons.add,size: 30,),),),
          ElevatedButton(
              onPressed: () async {
                int c = await DatabaseHelper().deleteNote(id!);
                if (c != 0) {
                  showCusSnackBar(context, 'Deleted Successfully....');
                } else {
                  showCusSnackBar(context, 'Some Error !!');
                }
                if(!inDetail)
                  Navigator.pop(context);
                else
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
              },
              child: Icon(
                Icons.done,
                size: 30,
              ),),
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

Widget CusText(String text,double size,bool isBold){
  return Text('$text',
      style: TextStyle(overflow: TextOverflow.ellipsis,color: textColor,fontWeight: isBold? FontWeight.bold: FontWeight.w300,fontSize: size),
  );
}