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
    ...message.toJson(),
    'receipt': receiptStatus.value(),
  };

  factory LocalMessage.fromMap(Map<String,dynamic> json){
    final message = Message(
      from: json['from'],
      to: json['to'],
      timeStap: json['timeStap'],
      content: json['content'],
    );

    final localMessage = LocalMessage(json['chat_id'], message,
        EnumParsing.fromString(json['receipt']));
    localMessage._id = json['id'];
    return localMessage;
  }




}