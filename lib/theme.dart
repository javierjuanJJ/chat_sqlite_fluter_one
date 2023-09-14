import 'package:chat2/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  backgroundColor: Colors.white
);

ThemeData lightTheme(BuildContext context) => ThemeData(
  primaryColor: kPrimary,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: appBarTheme,
  iconTheme: IconThemeData(color: kIconLight),
  textTheme: GoogleFonts.cabinTextTheme(
    Theme.of(context).textTheme).apply(displayColor: Colors.black),
  visualDensity: VisualDensity.adaptivePlatformDensity
);


ThemeData darkTheme(BuildContext context) => ThemeData(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kAppBarDark),
    textTheme: GoogleFonts.cabinTextTheme(
        Theme.of(context).textTheme).apply(displayColor: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity
);

bool isLightTheme(BuildContext context){
  return MediaQuery.of(context).platformBrightness == Brightness.light;
}