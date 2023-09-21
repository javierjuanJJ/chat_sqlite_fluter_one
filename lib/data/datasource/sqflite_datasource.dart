import 'dart:convert';

import 'package:chat1/src/models/receipt.dart';
import 'package:chat2/data/datasource/datasource_contract.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/models/local_message.dart';
import 'package:sqflite/sqflite.dart';

class SqlfliteDatasource implements IDatasource {
  final Database _db;

  const SqlfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.transaction((txn) async {
      await txn.insert('chats', chat.toMap(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.transaction((txn) async {
      await txn.insert('messages', message.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
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
     final listOfChatMaps = await txn.query('chats', orderBy: 'updates_at DESC');


      if (listOfChatMaps.isEmpty) return [];

      return await Future.wait(listOfChatMaps.
      map<Future<Chat>>((row) async {
        final unread = Sqflite.firstIntValue(
          await txn.rawQuery(
            'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
            [row['id'], 'deliverred']
          ),
        );
        final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [row['id']],
          orderBy: 'created_at DESC',
          limit: 1
        );
        final chat = Chat.fromMap(row);
        chat.unread = unread!;
        if (mostRecentMessage.isNotEmpty){
          chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
        }
        return chat;
      }));
    });
  }

  @override
  Future<Chat?> findChat(String chatId) async {
    return await _db.transaction((txn) async {
      final listOfMapChats =
          await txn.query('chats', where: 'id = ?', whereArgs: [chatId]);

      if (!listOfMapChats.isEmpty) {
        return null;
      }

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'delivered']));

      final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'created_at DESC',
          limit: 1);

      final chat = Chat.fromMap(listOfMapChats.first);
      chat.unread = unread!;

      if(mostRecentMessage.isNotEmpty){
        chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      }

      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps = await _db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );

    return listOfMaps
        .map<LocalMessage>((e) => LocalMessage.fromMap(e))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update('messages', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.message.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status) {
    return _db.transaction((txn) async {
      await txn.update('messages', {'receipt': status.value()},
          where: 'id = ?',
          whereArgs: [messageId],
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
}
