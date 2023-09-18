import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';
import 'package:chat2/states_management/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;
  HomeCubit(this._userService): super(HomeInitial());

  Future<void> activeUsers() async {
    emit(HomeLoading());
    final users = await _userService.online();
    emit(HomeSuccess(users));
  }

}