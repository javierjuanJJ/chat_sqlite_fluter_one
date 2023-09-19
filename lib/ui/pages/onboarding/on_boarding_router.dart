import 'package:chat1/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IOnBoardingRouter {
  void onSessionSuccess(BuildContext context, User me);
}

class OnBoardingRouter implements IOnBoardingRouter {

  final Widget Function(User me) onSessionConnected;

  OnBoardingRouter(this.onSessionConnected);

  @override
  void onSessionSuccess(BuildContext context, User me) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => onSessionConnected(me))
        , (Route<dynamic> route) => false
    );
  }

}