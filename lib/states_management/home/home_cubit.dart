import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';
import 'package:chat2/cache/local_cache.dart';
import 'package:chat2/states_management/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;
  ILocalCache _localCache;
  HomeCubit(this._userService, this._localCache): super(HomeInitial());

  Future<User> connect(User user) async {
    final userJson = _localCache.fetch('USER');
    userJson['last_seen'] = DateTime.now();
    userJson['active'] = true;

    final user = User.fromJson(userJson);
    await _userService.connect(user);
    return user;

  }

  Future<void> activeUsers(User user) async {
    emit(HomeLoading());
    final users = await _userService.online();
    users.removeWhere((element) => element.id == user.id);
    emit(HomeSuccess(users));
  }

}