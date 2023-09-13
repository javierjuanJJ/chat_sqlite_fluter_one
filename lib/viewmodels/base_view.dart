import 'package:chat2/data/datasource/datasource_contract.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/models/local_message.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseViewModel {
  IDatasource _datasource;
  BaseViewModel(this._datasource);
  @protected
  Future<void> addMessage(LocalMessage message) async{
    if (!await _isExistingChat(message.chatId)){
      await _createNewChat(message.chatId);
    }
    await _datasource.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _datasource.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = Chat(chatId);
    await _datasource.addChat(chat);
  }
}