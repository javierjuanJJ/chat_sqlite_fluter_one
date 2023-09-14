import 'package:chat1/chat.dart';
import 'package:chat2/data/services/image_uploader.dart';
import 'package:chat2/states_management/onboarding/onboarding_cubit.dart';
import 'package:chat2/states_management/onboarding/profile_image_cubit.dart';
import 'package:chat2/ui/pages/onboarding/on_boarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:bloc/bloc.dart';

class CompositionRoot{
  static late RethinkDb _r;
  static late Connection _connection;
  static late IUserService _userService;

  static configure() async {
    _r = RethinkDb();
    _connection = await _r.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_r, _connection);
  }

  static Widget composeOnBoardingUI(){
    ImageUploader imageUploader = ImageUploader('http://' + '127.0.0.1' + ':3000/uploads');
    OnBoardingCubit onBoardingCubit = OnBoardingCubit(_userService, imageUploader);
    ProfileImageCubit imageCubit = ProfileImageCubit();

    return MultiBlocProvider(
      providers:[
        BlocProvider(create: (BuildContext context) => onBoardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: OnBoarding(),
    );
  }
}