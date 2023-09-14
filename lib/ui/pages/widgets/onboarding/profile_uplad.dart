import 'package:chat2/colors.dart';
import 'package:chat2/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileUpload extends StatelessWidget {
  const ProfileUpload();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126.0,
      width: 126.0,
      child: Material(
        color: isLightTheme(context) ? Color(0xFF2F2F2) : Color(0xFF211E1E),
        borderRadius: BorderRadius.circular(126.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(126.0),
          onTap: () {

          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(

                backgroundColor: Colors.transparent,

                child: Icon(
                    Icons.person_outline_rounded,
                  size: 126.0,
                  color: isLightTheme(context) ? kIconLight : Colors.black,
                ),


              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.add_circle_rounded,
                  color: kPrimary,
                  size: 38.0,
                ),
              ),
            ],

          ),

        ),
      ),
    );
  }
}
