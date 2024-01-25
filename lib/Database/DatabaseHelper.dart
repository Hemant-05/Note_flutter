import 'dart:io';
import 'package:note/Resources/NoteModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final _dbName = 'note_db';
  static final _dbVersion = 3;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  _initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,
        _dbName); // join function is not recognized directly first we import path package and than use it.
    return await openDatabase(
        path,
        onCreate: (Database db, int version) async {
          await db.execute(
              '''create table notes(id integer primary key autoincrement,title text,content text,date text, time text,imp integer)''');
        },
        version: _dbVersion
    );
  }
  //for retrieve all notes
  Future<List<Note>> getNotes() async {
    Database db = await database;
    List<Map<String, dynamic>> notes = await db.query('notes');
    return List.generate(notes.length, (i) => Note.fromJson(notes[i]),);
  }
  // for inserting a note
  Future<int> insertNote(Note note) async {
    Database db = await database;
    return await db.insert('notes', note.toJson());
  }
  Future<int> updateNote(Note note) async {
    Database db = await database;
    return await db
        .update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
  }
  Future<int> deleteNote(int id) async {
    Database db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}