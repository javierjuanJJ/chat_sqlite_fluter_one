import 'package:bloc/bloc.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/viewmodels/chat_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final Chats_View_Model _viewModel;
  ChatsCubit(this._viewModel) : super([]);

  Chats_View_Model get viewModel => _viewModel;

  Future<void> chats() async {
    final chats = await _viewModel.getChats();
    emit(chats);
  }
}