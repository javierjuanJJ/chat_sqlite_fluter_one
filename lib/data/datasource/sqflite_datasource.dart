import 'dart:convert';

import 'package:chat2/data/datasource/datasource_contract.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/models/local_message.dart';
import 'package:sqflite/sqflite.dart';

class SqlfliteDatasource implements IDatasource{

  final Database _db;
  const SqlfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.insert('chats', chat.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.insert('messages', message.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() async {
    return _db.transaction((txn) async {
      final chatWithLatestMessage = await txn.rawQuery(''' SELECT messages.* FROM 
      (SELECT
        chat_id, 
        MAX(created_at) AS created_at,
        FROM messages
        GROUP BY chat_id
      ) AS latest_messages
      INNER JOIN messages
      ON messages.chat_id = latest_messages.chat_id
      AND messages.created_at = latest_messages.created_at
       ''');


      if (chatWithLatestMessage.isEmpty) return[];

      final chatsWithUnreadMessages = await txn.rawQuery(''' SELECT chat_id, count(*) as unreadable_messages
      FROM messages
      WHERE receipt = ?
      GROUP BY chat_id
      ''', ['delivered']);
      return chatWithLatestMessage.map<Chat>((row) {
        final int? unread = int.tryParse((chatsWithUnreadMessages.firstWhere((element) => row['chat_id'] == element['chat_id'], orElse: () => {'unread': 0})['unread']).toString());

        final chat = Chat.fromMap(row);
        chat.unread = unread!;
        chat.mostRecent = LocalMessage.fromMap(row);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat?> findChat(String chatId) async {
    return await _db.transaction((txn) async {
      final listOfMapChats = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId]
      );

      if (!listOfMapChats.isEmpty){
        return null;
      }

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'delivered']
        ));

      final mostRecentMessage = await txn.query('messages',
        where: 'chat_id = ?',
        whereArgs: [chatId],
        orderBy: 'created_at DESC',
        limit: 1
      );

      final chat = Chat.fromMap(listOfMapChats.first);
      chat.unread = unread!;
      chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);

      return chat;


    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps = await _db.query('messages',
    where: 'chat_id = ?',
      whereArgs: [chatId],
    );

    return listOfMaps.map<LocalMessage>((e) => LocalMessage.fromMap(e)).toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update('messages', message.toMap(),
      where: 'id = ?',
      whereArgs: [message.message.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

}