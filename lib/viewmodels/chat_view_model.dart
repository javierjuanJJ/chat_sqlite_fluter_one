import 'package:chat1/chat.dart';
import 'package:chat2/data/datasource/datasource_contract.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/models/local_message.dart';
import 'package:chat2/viewmodels/base_view.dart';

class Chats_View_Model extends BaseViewModel{
  Chats_View_Model(this._datasource) : super(_datasource);
  IDatasource _datasource;


  Future<List<Chat>> getChats() async => await _datasource.findAllChats();


  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(message.from, message, ReceiptStatus.delicerres);
    await addMessage(localMessage);
  }



}