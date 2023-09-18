import 'package:chat2/colors.dart';
import 'package:chat2/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnlineIndicator extends StatefulWidget {
  const OnlineIndicator();

  @override
  State<OnlineIndicator> createState() => _OnlineIndicatorState();
}

class _OnlineIndicatorState extends State<OnlineIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.0,
      width: 15.0,
      decoration: BoxDecoration(
        color: kIndicatorBubble,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 3.0,
          color: isLightTheme(context) ? Colors.white: Colors.black
        ),
      ),
    );
  }
}
