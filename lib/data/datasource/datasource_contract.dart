import 'package:chat2/models/chat.dart';
import 'package:chat2/models/local_message.dart';

abstract class IDatasource {
  Future<void> addChat(Chat chat);
  Future<void> addMessage(LocalMessage message);
  Future<Chat> findChat(String chatId);
  Future<List<Chat>> findAllChats();
  Future<void> updateMessage(LocalMessage message);
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> deleteChat(String chatId);

}