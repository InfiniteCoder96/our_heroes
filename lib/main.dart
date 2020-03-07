import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:our_heroes/screens/onboarding_screen.dart';
import 'package:our_heroes/screens/Login.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Heroes',
      debugShowCheckedModeBanner: false,
      home: initScreen != null || initScreen == 1 ? OnboardingScreen() : Login(),
    );
  }
}