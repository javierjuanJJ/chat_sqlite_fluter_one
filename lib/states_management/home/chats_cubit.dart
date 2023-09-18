import 'package:bloc/bloc.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/viewmodels/chat_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final Chats_View_Model viewModel;
  ChatsCubit(this.viewModel) : super([]);

  Future<void> chats() async {
    final chats = await viewModel.getChats();
    emit(chats);
  }
}