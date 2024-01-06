import 'package:flutter/material.dart';
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
  TextEditingController searchCon = TextEditingController();

  Future onRefreshFun() async {
    setState(() {});
  }

  void onSearchFun(String search) async{
    list.clear();
    list = await dbHelper.getNotes();
    setState(() {
      list.forEach((note) {
        if(note.content.toLowerCase().contains(search.toLowerCase(),) ||
            note.title.toLowerCase().contains(search.toLowerCase(),)){
          searchList.add(note);
        }
      });
    });
  }
  Future<List<Note>> getSearchList() async{
    print('Search list length is : ${searchList.length}');
    return searchList;
  }
  Widget search(Size size) {
    return SearchBar(
      controller: searchCon,
      leading: Icon(Icons.search_rounded),
      hintText: 'Search your note',
      trailing: [
        Visibility(
            visible: isSearch,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isSearch = false;
                });
                searchCon.clear();
                searchList.clear();
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
          maxWidth: isSearch ? size.width * .85 : 40,
          minHeight: 40),
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
    );
  }

  Widget ListBuilder(BuildContext context) {
    return FutureBuilder(
      future: isSearch? getSearchList() : dbHelper.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          list = snapshot.data!;
          return list.length == 0
              ? Center(
                  child: CusText('No Notes here', 40, true),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        onLongPress: () {
                          showCusDeleteDialog(context, list[index].id, false);
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailsScreen(note: list![index]),
                            ),
                          );
                        },
                        leading: CusText('${index + 1}', 16, true),
                        title: CusText('${list[index].title}', 18, true),
                        subtitle: Text(
                          '${list[index].content}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textColor),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RotatedBox(
                              quarterTurns: 0,
                              child: CusText('${list[index].date}', 13, false),
                            ),
                            CusText('${list[index].time}', 12, false),
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
}
