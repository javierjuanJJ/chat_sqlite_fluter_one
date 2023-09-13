import 'package:chat1/chat.dart';
import 'package:chat2/models/local_message.dart';

import '../data/datasource/datasource_contract.dart';
import 'base_view.dart';

class Chat_View_Model extends BaseViewModel {
  Chat_View_Model(this._datasource) : super(_datasource);
  IDatasource _datasource;
  String _chatId = '';
  int otherMessages = 0;

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _datasource.findMessages(chatId);
    if (messages.isNotEmpty) chatId = _chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(message.to, message, ReceiptStatus.sent);
    if (_chatId.isNotEmpty){
      return await _datasource.addMessage(localMessage);
    }
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async{
    LocalMessage localMessage = LocalMessage(message.from, message, ReceiptStatus.delicerres);
    if (localMessage.chatId != _chatId){
      otherMessages++;
    }
    await addMessage(localMessage);
  }

}