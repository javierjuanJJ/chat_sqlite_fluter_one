import 'dart:convert';

import 'package:chat1/chat.dart';

class LocalMessage{
  String chatId;
  String get id => _id;
  late String _id;
  Message message;
  ReceiptStatus receiptStatus;

  LocalMessage(this.chatId, this.message, this.receiptStatus);

  Map<String, dynamic> toMap() => {
    'chat_id': chatId,
    'id': message.id,
    'sender': message.from,
    'receiver' : message.to,
    'contents': message.content,
    'received_at': message.timeStap.toString(),
    'receipt': receiptStatus.value(),
    'group_id': message.groupId,
    ...message.toJson(),
  };

  factory LocalMessage.fromMap(Map<String,dynamic> json){
    final message = Message(
      from: json['sender'],
      to: json['receiver'],
      timeStap: DateTime.parse(json['received_at']),
      content: json['contents'],
      groupId: json['group_id'],
    );

    final localMessage = LocalMessage(json['chat_id'], message,
        EnumParsing.fromString(json['receipt']));
    localMessage._id = json['id'];
    return localMessage;
  }




}