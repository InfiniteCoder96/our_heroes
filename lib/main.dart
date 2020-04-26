import 'package:flutter/material.dart';
import 'package:our_heroes/models/user.dart';
import 'package:our_heroes/screens/home/home_screen.dart';
import 'package:our_heroes/screens/wrapper.dart';
import 'package:our_heroes/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:our_heroes/screens/onboarding_screen.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().userAuthState,
        child: MaterialApp(
          title: 'Our Heroes',
          debugShowCheckedModeBanner: false,
          home: initScreen == 0 || initScreen == null ? OnboardingScreen() : Wrapper(),
          routes: {
            "/home": (_) => new HomeScreen(),
          },
        ),
    );
  }
}