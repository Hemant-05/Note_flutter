import 'package:flutter/material.dart';
import 'package:note/Custom/cusAddNoteDialog.dart';
import 'package:note/Custom/cusDeleteDialog.dart';
import 'package:note/Custom/cusSnackBar.dart';
import 'package:note/Custom/cusText.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/FirebaseAuth/FirebaseAuth.dart';
import 'package:note/Provider/NoteProvider.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:note/Resources/Utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.openDrawer});

  final VoidCallback openDrawer;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuthServices services = FirebaseAuthServices();
  bool isSearch = false;
  final dbHelper = DatabaseHelper();
  List<Note> list = [];
  List<Note> searchList = [];
  FocusNode focusNode = FocusNode();
  TextEditingController searchCon = TextEditingController();
  int imp = 0;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<NoteProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.menu), onPressed: () => widget.openDrawer(),),
          title: cusText('My Notes', 22, true),
          actions: [
            search(size),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: ListViewBuilder(context, value),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: () {
            AddNote().showCusAddNoteDialog(context, value);
          },
          tooltip: 'Add new note',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchCon.dispose();
    focusNode.dispose();
  }

  void onSearchFun(String search) async {
    list.clear();
    searchList.clear();
    list = await dbHelper.getNotes();
    setState(() {
      for (var note in list) {
        if (note.content.toLowerCase().contains(
                  search.toLowerCase(),
                ) ||
            note.title.toLowerCase().contains(
                  search.toLowerCase(),
                )) {
          searchList.add(note);
        }
      }
    });
  }

  Widget search(Size size) {
    return SearchBar(
      controller: searchCon,
      leading: Icon(Icons.search_rounded),
      hintText: 'Search your note here',
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
        maxWidth: isSearch ? size.width * .8 : 40,
        minHeight: 40,
        maxHeight: 40,
      ),
    );
  }

  Widget ListViewBuilder(BuildContext context, NoteProvider value) {
    List<Note> itemList = isSearch ? searchList : value.noteList;
    String textWhenNoNote =
        isSearch ? 'Search Note here' : 'Note note here \n Add new note';
    return itemList.isEmpty
        ? Center(child: cusText(textWhenNoNote, 30, true))
        : ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              Note note = itemList[index];
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, 'details', arguments: note);
                  },
                  onLongPress: () {
                    showCusDeleteDialog(context, note, false, value);
                  },
                  title: cusText('${note.title}', 18, true),
                  subtitle: Text(
                    '${note.content}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: note.imp == 1,
                        child: const RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            Icons.label_important,
                          ),
                        ),
                      ),
                      cusText(
                        '${note.time}',
                        12,
                        true,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
