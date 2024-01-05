import 'package:flutter/material.dart';
import 'package:note/Custom/custom_item.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/Resources/Colors.dart';
import 'package:note/Resources/NoteModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearch = false;
  final dbHelper = DatabaseHelper();
  List<Note>? list;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          AppBar(context, size),
          Expanded(child: ListBuilder(context))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showNewCusDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add new task',
      )
    );
  }
  Widget ListBuilder(BuildContext context)  {
    return FutureBuilder(future: dbHelper.getNotes(), builder: (context, snapshot) {
      if(snapshot.data != null) {
        list = snapshot.data;
        return ListView.builder(itemCount: list?.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.grey,
              margin: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
              child: ListTile(
                onLongPress: (){
                  showCusDeleteDialog(context, list![index].id);
                },
                leading: Text('${index+1}'),
                title: Text('${list?[index].title}'),
                subtitle: Text('${list?[index].content}'),
                trailing: Text('${list?[index].date}'),
              ),
            );
          },);
      }else{
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },);
  }

  Widget AppBar(BuildContext context, Size size) {
    return Container(
      width: size.width,
      height: size.height * .2,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * .85),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Note',
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
