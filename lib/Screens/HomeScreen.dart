import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/Custom/custom_item.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/Provider/NoteProvider.dart';
import 'package:note/Resources/NoteModel.dart';
import 'package:note/Resources/Utils.dart';
import 'package:note/Screens/NoteDetailsScreen.dart';
import 'package:note/Screens/SettingsScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int imp = 0;
  int selectedIndex = 0;

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
          print('Note item details : ${note.content}');
          searchList.add(note);
        }
      }
    });
  }

  void addNote(String title, String content, NoteProvider value) async {
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
      imp = 0;
      Navigator.pop(context);
    } else {
      showCusSnackBar(context, 'Write something');
      Navigator.pop(context);
    }
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
        maxWidth: isSearch? size.width * .8 : 40,
        minHeight: 40,
        maxHeight: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<NoteProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
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
            showCusAddNoteDialog(context, value);
          },
          child: Icon(Icons.add),
          tooltip: 'Add new note',
        ),
        drawer: Drawer(
          width: 250,
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: cusText(
                    'My Notes',
                    40,
                    true,
                  ),
                ),
              ),
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(),
                  ),
                ),
                title: cusText('Settings', 24, true),
                trailing: const Icon(
                  Icons.settings,
                  size: 28,
                ),
              ),
              ListTile(
                onTap: () async {
                  final Uri url = Uri.parse(git_url);
                  if(!await launchUrl(url,mode: LaunchMode.externalApplication)){
                    showCusSnackBar(context, 'Error while opening web');
                  }
                },
                title: cusText('Source Code', 24, true),
                trailing: const Icon(
                  Icons.code
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ListViewBuilder(BuildContext context, NoteProvider value) {
    List<Note> itemList = isSearch? searchList: value.noteList;
    String textWhenNoNote = isSearch? 'Search Note here' : 'Note note here \n Add new note';
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
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailsScreen(note: note),
                      ),
                    );
                  },
                  onLongPress: (){
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
                      cusText('${note.time}', 12, true),
                    ],
                  ),
                ),
              );
            },
          );
  }

  showCusAddNoteDialog(BuildContext context, NoteProvider value) {
    Size size = MediaQuery.of(context).size;
    TextEditingController titleCon = TextEditingController();
    TextEditingController contentCon = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Dialog(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxHeight: 70),
                      child:
                          cusTextField('Enter Title', titleCon, 1, size, true),
                    ),
                    hGap(14),
                    Expanded(
                      child: cusTextField('Write your note here....',
                          contentCon, null, size, true),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                          trackOutlineWidth: MaterialStatePropertyAll(2),
                          value: imp == 1,
                          onChanged: (value) {
                            setState(() {
                              imp = value ? 1 : 0;
                            });
                          },
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        var title = titleCon.text.toString();
                        var content = contentCon.text.toString();
                        addNote(title, content, value);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
