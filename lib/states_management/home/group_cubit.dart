import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';

class GroupCubit extends Cubit<List<User>> {
  GroupCubit(): super([]);

  add(User user){
    state.add(user);
    emit(List.from(state));
  }

  remove(User user){
    state.removeWhere((element) => element.id == user.id);
    emit(List.from(state));
  }

}