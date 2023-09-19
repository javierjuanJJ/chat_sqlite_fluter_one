import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';
import 'package:flutter/animation.dart';

import '../../cache/local_cache.dart';
import '../../data/services/image_uploader.dart';
import 'onboarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState>{
  final IUserService _userService;
  final ImageUploader _imageUploader;
  final ILocalCache _localCache;


  OnBoardingCubit(this._userService, this._imageUploader, this._localCache) : super(OnBoardingInitial());

  Future<void> connect(String name, File profileImage) async {
    emit(Loading());
    final url = await _imageUploader.uploadImage(profileImage);
    if (url != null){
      final user = User(username: name, photoUrl: url, active: true, lastSeen: DateTime.now());

      final createdUser = await _userService.connect(user);
      final userJson = {
        'username' : createdUser.username,
        'active' : true,
        'photo_url' : createdUser.photoUrl,
        'id' : createdUser.id,
      };
      await _localCache.save('USER', userJson);
      emit(OnBoardingSuccess(createdUser));
    }

  }
}