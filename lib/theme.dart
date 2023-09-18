import 'package:chat2/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  backgroundColor: Colors.white
);

final tabBarTheme = TabBarTheme(
  indicatorSize: TabBarIndicatorSize.label,
  unselectedLabelColor: Colors.black54,
  indicator: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    color: kPrimary,
  ),
);

ThemeData lightTheme(BuildContext context) => ThemeData(
  primaryColor: kPrimary,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: appBarTheme,
  dividerTheme:  dividerTheme.copyWith(color: kIconLight),
  iconTheme: IconThemeData(color: kIconLight),
  tabBarTheme: tabBarTheme,
  textTheme: GoogleFonts.cabinTextTheme(
    Theme.of(context).textTheme).apply(displayColor: Colors.black),
  visualDensity: VisualDensity.adaptivePlatformDensity
);

final dividerTheme = DividerThemeData().copyWith(thickness: 1.0, indent: 75.0);



ThemeData darkTheme(BuildContext context) => ThemeData(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: appBarTheme,
    dividerTheme:  dividerTheme.copyWith(color: kBubbleDark),
    tabBarTheme: tabBarTheme.copyWith(unselectedLabelColor: Colors.white70),
    iconTheme: IconThemeData(color: kAppBarDark),
    textTheme: GoogleFonts.cabinTextTheme(
        Theme.of(context).textTheme).apply(displayColor: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity
);

bool isLightTheme(BuildContext context){
  return MediaQuery.of(context).platformBrightness == Brightness.light;
}