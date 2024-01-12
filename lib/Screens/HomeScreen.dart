import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/Custom/custom_item.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/Resources/Colors.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:note/Screens/NoteDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearch = false;
  final dbHelper = DatabaseHelper();
  List<Note> list = [];
  List<Note> searchList = [];
  FocusNode focusNode = FocusNode();
  TextEditingController searchCon = TextEditingController();
  int imp = 1;
  bool check = false;

  Future onRefreshFun() async {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    searchCon.dispose();
    focusNode.dispose();
  }

  void onSearchFun(String search) async {
    list.clear();
    list = await dbHelper.getNotes();
    setState(() {
      list.forEach((note) {
        if (note.content.toLowerCase().contains(
                  search.toLowerCase(),
                ) ||
            note.title.toLowerCase().contains(
                  search.toLowerCase(),
                )) {
          searchList.add(note);
        }
      });
    });
  }

  Future<List<Note>> getSearchList() async {
    return searchList;
  }

  Widget search(Size size) {
    return SearchBar(
      controller: searchCon,
      leading: Icon(Icons.search_rounded),
      hintText: 'Search your note',
      focusNode: focusNode,
      trailing: [
        Visibility(
          visible: isSearch,
          child: IconButton(
            onPressed: () {
              setState(() {
                isSearch = false;
                searchCon.clear();
                searchList.clear();
                focusNode.unfocus();
              });
            },
            icon: Icon(Icons.highlight_remove_rounded),
          ),
        ),
      ],
      onChanged: (query) => onSearchFun(query),
      onTap: () {
        setState(() {
          isSearch = true;
        });
      },
      constraints: BoxConstraints(
          maxWidth: isSearch ? size.width * .85 : 40, minHeight: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          CusAppBar(context, size.width, size.height * 0.2, 'Notes', '',
              search(size), isSearch),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefreshFun,
              child: ListBuilder(context),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCusAddNoteDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add new task',
      ),
      drawer: Drawer(
        width: 250,
        backgroundColor: Colors.grey,
        child: ListView(
          children: [
            DrawerHeader(
              child: Container(
                color: Colors.green,
              ),
            ),
            ListTile(title: Text('tile : 1'),),
            ListTile(title: Text('tile : 2'),),
          ],
        ),
      ),
    );
  }

  Widget ListBuilder(BuildContext context) {
    String st = isSearch ? 'Search Notes here ' : 'No Notes here';
    return FutureBuilder(
      future: isSearch ? getSearchList() : dbHelper.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          list = snapshot.data!;
          list.sort((a, b) => b.id!.compareTo(a.id!));
          return list.length == 0
              ? Center(
                  child: cusText('$st', 40, true),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailsScreen(note: list[index]),
                            ),
                          );
                        },
                        leading: cusText('${index + 1}', 16, true),
                        title: cusText('${list[index].title}', 18, true),
                        subtitle: Text(
                          '${list[index].content}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textColor),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              maxRadius: 5,
                              backgroundColor: list[index].imp == 1 ? Colors.red : Colors.grey,
                            ),
                            hGap(6),
                            cusText('${list[index].date}', 13, false),
                            cusText('${list[index].time}', 12, false),
                          ],
                        ),
                      ),
                    );
                  },
                );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  showCusAddNoteDialog(BuildContext context) {
    TextEditingController titleCon = TextEditingController();
    TextEditingController contentCon = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) => Dialog(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 300),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxHeight: 70),
                          child: cusTextField('Enter Title', titleCon, 1),
                        ),
                        hGap(12),
                        Expanded(
                          child: cusTextField(
                              'Write your note here....', contentCon, null),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Important ? ',style: TextStyle(fontSize: 20,),),
                            Switch(
                              value: check,
                              onChanged: (value) {
                                setState(() {
                                  imp = value? 1 : 0;
                                  check = value;
                                });
                              },
                            )
                          ],
                        ),
                        hGap(18),
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
                                time: '$time',
                                imp: imp,
                              );
                              await DatabaseHelper().insertNote(note);
                              check = false;
                              imp = 0;
                              Navigator.pop(context);
                            } else {
                              showCusSnackBar(context, 'Write something');
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Save'),
                        )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
