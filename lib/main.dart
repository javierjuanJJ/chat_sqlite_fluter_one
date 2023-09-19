import 'package:chat2/composition_root.dart';
import 'package:chat2/theme.dart';
import 'package:chat2/ui/pages/home/home/home.dart';
import 'package:chat2/ui/pages/onboarding/on_boarding.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final firstPage = CompositionRoot.start();
  runApp(MyApp(firstPage));
}

class MyApp extends StatelessWidget {
  final Widget firstPage;
  const MyApp(this.firstPage);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: firstPage,
    );
  }
}