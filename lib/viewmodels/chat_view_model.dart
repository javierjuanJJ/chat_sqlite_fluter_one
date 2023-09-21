import 'package:chat1/chat.dart';
import 'package:chat2/data/datasource/datasource_contract.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/models/local_message.dart';
import 'package:chat2/viewmodels/base_view.dart';

class Chats_View_Model extends BaseViewModel {
  late int otherMessages;

  Chats_View_Model(this._datasource, this._userService) : super(_datasource, _userService);
  IDatasource _datasource;
  late IUserService _userService;
  late String _chatId;

  Future<List<Chat>> getMessages(String chatId) async {
    final List<Chat> messages = (await _datasource.findMessages(chatId)).cast<Chat>();
    if (messages.isNotEmpty){
      _chatId = chatId;
    }
    return messages;
  }
  Future<List<Chat>> getChats() async {
   final List<Chat> chats = await _datasource.findAllChats();
   await Future.forEach(chats, (Chat chat2) async {
     final Chat chat = chat2;
     final ids = chat.membersId?.map<String>((e)=>e.keys.first).toList();
     final user = await _userService.fetch(ids!);
     chat2.members = user;
   });
   return chats;
  }


  Future<void> receivedMessage(Message message) async {
    final chatId = message.groupId != null ? message.groupId : message.from ;
    LocalMessage localMessage = LocalMessage(chatId, message, ReceiptStatus.delicerres);
    if(_chatId.isEmpty){
      _chatId = localMessage.chatId;
    }
    if(localMessage != _chatId){
      otherMessages++;
    }
    await addMessage(localMessage);
  }

  Future<void> sendMessage(Message message) async {
    final chatId = message.groupId != null ? message.groupId : message.from ;
    LocalMessage localMessage = LocalMessage(chatId, message, ReceiptStatus.sent);
    if(_chatId.isNotEmpty){
      return await _datasource.addMessage(localMessage);
    }
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _datasource.updateMessageReceipt(receipt.messageId, receipt.status);
  }


}