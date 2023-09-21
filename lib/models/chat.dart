import 'dart:convert';

import 'package:chat1/chat.dart';
import 'package:chat2/models/local_message.dart';

enum ChatType { individual, group }

extension EnumParsing on ChatType {
  String value() {
    return this.toString().split('.').last;
  }

  static ChatType fromString(String status) {
    return ChatType.values.firstWhere((element) => element.value() == status);
  }
}

class Chat {
  String _id;
  int unread = 0;
  late List<LocalMessage>? messages = [];
  late LocalMessage? mostRecent;
  late User _from;
  ChatType type;
  List<User>? members;
  List<Map>? membersId;
  String? name;

  set from(User value) {
    _from = value;
  }

  User get from => _from;

  Chat(
    this._id,
    this.type, {
    this.messages,
    this.mostRecent,
    this.members,
    this.membersId,
    this.name,
  });

  String get id => _id;

  toMap() => {'id': _id};

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
        json['id'],
        EnumParsing.fromString(json['type']),
        membersId: List<Map>.from(
            json['members'].split(",").map((e) => jsonDecode(e))),
        name: json['name'],
      );
}
