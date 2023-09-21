import 'package:chat1/chat.dart';
import 'package:chat1/src/services/user/user_service_contract.dart';
import 'package:chat2/data/datasource/datasource_contract.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/models/local_message.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseViewModel {
  IDatasource _datasource;
  BaseViewModel(this._datasource, IUserService userService);
  @protected
  Future<void> addMessage(LocalMessage message) async{
    if (!await _isExistingChat(message.chatId)){
      final chat = Chat(message.chatId, ChatType.individual, membersId: [
        //{message.chatId = ""}
      ]);
      await createNewChat(chat);
    }
    await _datasource.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _datasource.findChat(chatId) != null;
  }

  Future<void> createNewChat(Chat chatId) async {
    final chat = Chat(chatId.id, chatId.type);
    await _datasource.addChat(chat);
  }
}