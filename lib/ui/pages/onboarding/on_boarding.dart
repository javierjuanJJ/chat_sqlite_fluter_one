import 'package:chat2/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/onboarding/logo.dart';
import '../widgets/onboarding/profile_uplad.dart';
import '../widgets/shared/custom_text.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logo(context),
              Spacer(),
              ProfileUpload(),
              Spacer(
                flex: 1,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomTextField(
                  hint: 'What`s your name?',
                  height: 45.0,
                  onchanged: (val) {},
                  inputAction: TextInputAction.none,
                ),
              ),
              Spacer(
                flex: 2,
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      'Meet with me chat',
                      style: Theme.of(context).textTheme.button?.copyWith(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kPrimary,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Laba',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 8.0,
        ),
        Logo(),
        Text(
          'Laba',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}