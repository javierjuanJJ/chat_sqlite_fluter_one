import 'package:chat1/chat.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {

}

class HomeInitial extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class HomeLoading extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class HomeSuccess extends HomeState {

  final List<User> onlineUsers;
  HomeSuccess(this.onlineUsers);

  @override
  // TODO: implement props
  List<Object?> get props => [onlineUsers];
}