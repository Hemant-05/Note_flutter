import 'package:flutter/cupertino.dart';
import 'package:note/Database/DatabaseHelper.dart';
import 'package:note/Resources/NoteModel.dart';

class NoteProvider extends ChangeNotifier{
  DatabaseHelper helper = DatabaseHelper();
  List<Note> noteList = [];

  NoteProvider(){
    getAllNote();
  }

  Future<List<Note>> getAllNote() async {
    noteList = await helper.getNotes();
    noteList.sort((a, b)=> a.id ?? 0.compareTo(b.id ?? 1));
    notifyListeners();
    return noteList;
  }
  Future<int> insertNote(Note note) async{
    int val = await helper.insertNote(note);
    getAllNote();
    notifyListeners();
    return val;
  }
  Future<int> deleteNote(int id) async{
    int val = await helper.deleteNote(id);
    getAllNote();
    notifyListeners();
    return val;
  }
  Future<int> updateNote(Note note) async{
    int val = await helper.updateNote(note);
    getAllNote();
    notifyListeners();
    return val;
  }
}