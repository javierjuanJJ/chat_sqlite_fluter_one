import 'package:chat1/chat.dart';
import 'package:chat2/data/datasource/datasource_contract.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/models/local_message.dart';
import 'package:chat2/viewmodels/base_view.dart';

class Chats_View_Model extends BaseViewModel{
  Chats_View_Model(this._datasource, this._userService) : super(_datasource, _userService);
  IDatasource _datasource;
  late IUserService _userService;


  Future<List<Chat>> getChats() async {
   final List<Chat> chats = await _datasource.findAllChats();
   await Future.forEach(chats, (chat2) async {
     final Chat chat = chat2 as Chat ;
     final user = await _userService.fetch(chat.id);
     chat2.from = user;
   });
   return chats;
  }


  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(message.from, message, ReceiptStatus.delicerres);
    await addMessage(localMessage);
  }



}