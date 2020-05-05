import 'dart:async';
import 'dart:io' as io;

import 'package:coronapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String databaseName = "coronapp.db";
  final int databaseVersion = 1;

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory docDir = await getApplicationDocumentsDirectory();
    debugPrint(docDir.path);
    String path = join(docDir.path, databaseName);
    var theDb =
    await openDatabase(path, version: databaseVersion, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE user(id INTEGER PRIMARY KEY autoincrement, name TEXT, email TEXT, password TEXT, photo TEXT)");
  }

  Future<int> saveUser(User u) async {
    var dbClient = await db;
    int res = await dbClient.insert("user", u.toMap());
    debugPrint("$res");
    return res;
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM user ORDER BY name');
    List<User> users = new List();
    for (int i = 0; i < list.length; i++) {
      var u = new User(list[i]["id"], list[i]["name"], list[i]["email"],
          list[i]["password"], list[i]["photo"]);
      users.add(u);
    }

    print(users.length);

    return users;
  }

  Future<User> validateLogin(String email, String password) async {
    var dbClient = await db;
    User user;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM user WHERE email = ? and password = ?',
        [email, password]);
    if (list != null && list.length > 0)
      user = User(list[0]["id"], list[0]["name"], list[0]["email"],
          list[0]["password"], list[0]["photo"]);
    return user;
  }

  Future<int> deleteUser(User u) async {
    var dbClient = await db;

    int res = await dbClient.rawDelete('DELETE FROM user WHERE id = ?', [u.id]);
    return res;
  }

  Future<bool> updateUser(User u) async {
    var dbClient = await db;

    int res = await dbClient
        .update("user", u.toMap(), where: "id = ?", whereArgs: <int>[u.id]);

    return res > 0 ? true : false;
  }
}
