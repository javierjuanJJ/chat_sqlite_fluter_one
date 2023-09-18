import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class LocalDatabaseFactory {
  Future<Database> createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'db_sqlite.db');
    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database db, int version) async {
    await _createChatTable(db);
    await _createMessagesTable(db);
  }

  _createChatTable(Database db) async {
    await db.execute(
        """CREATE TABLE chats(
          id TEXT PRIMARY KEY,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
        )"""
    ).then((_) => print('creating table chats ....')).catchError((e) => print('Error creating chats table: $e'));
  }

  _createMessagesTable(Database db) async {
    await db.execute(
        """
          CREATE TABLE messages(
            chat_id TEXT NOT NULL,
            id TEXT PRIMARY KEY,
            sender TEXT NOT NULL,
            receiver TEXT NOT NULL,
            contents TEXT NOT NULL,
            receipt TEXT NOT NULL,
            received_at TIMESTAMP NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
        )"""
    ).then((_) => print('creating table chats ....')).catchError((e) => print('Error creating chats table: $e'));
  }

}