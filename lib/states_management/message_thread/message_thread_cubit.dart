import 'package:bloc/bloc.dart';
import 'package:chat2/models/local_message.dart';
import 'package:chat2/viewmodels/chats_view_model.dart';
import '../../viewmodels/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>>{
  final Chat_View_Model viewModel;
  MessageThreadCubit(this.viewModel): super([]);

  Future<void> messages(String chatId) async {
    final messages = await viewModel.getMessages(chatId);
    emit(messages);
  }

}