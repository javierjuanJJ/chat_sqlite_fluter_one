import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';

abstract class OnBoardingState extends Equatable {

}

class OnBoardingInitial extends OnBoardingState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loading extends OnBoardingState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnBoardingSuccess extends OnBoardingState {
  final User _user;
  OnBoardingSuccess(this._user);
  @override
  // TODO: implement props
  List<Object?> get props => [_user];
}