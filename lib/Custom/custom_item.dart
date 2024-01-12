import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/Resources/Colors.dart';
import 'package:note/Screens/HomeScreen.dart';

Widget CusAppBar(BuildContext context, double wi, double hi, String title,
    String time, Widget widget, bool isSearch) {
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
                child: Container(
                  constraints: BoxConstraints(maxWidth: wi * .7),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: cusText(title, 40, true),
                  ),
                ),
              ),
              Visibility(
                visible: !(title == 'Notes'),
                child: cusText('Last Updated $time', 16, true),
              ),
            ],
          ),
          widget,
        ],
      ),
    ),
  );
}

showCusDeleteDialog(BuildContext context, int? id, bool inDetail) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(
          Icons.delete_forever_outlined,
          size: 40,
          color: Colors.red,
        ),
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
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              int c = await DatabaseHelper().deleteNote(id!);
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
            child: Icon(
              Icons.done,
              size: 30,
            ),
          ),
        ],
      );
    },
  );
}

Widget hGap(double x) {
  return SizedBox(height: x);
}

Widget cusTextField(
    String label, TextEditingController controller, int? maxLines) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 400),
    child: TextField(
      controller: controller,
      autofocus: true,
      minLines: null,
      maxLines: maxLines,
      // expands: true,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textAlignVertical: TextAlignVertical.center,
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

Widget cusText(String text, double size, bool isBold) {
  return Text(
    '$text',
    style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: textColor,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
        fontSize: size),
  );
}
