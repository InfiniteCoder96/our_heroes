import 'dart:async';

import 'package:flutter/material.dart';
import 'package:our_heroes/models/user.dart';
import 'package:our_heroes/screens/home/home_screen.dart';
import 'package:our_heroes/screens/wrapper.dart';
import 'package:our_heroes/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:our_heroes/screens/onboarding_screen.dart';
import 'package:connectivity/connectivity.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var subscription;

  @override
  initState() {
    super.initState();

    Timer.run(() {
      try {
        subscription = Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult result) {
          if (result == ConnectivityResult.mobile) {
            // I am connected to a mobile network.
          } else if (result == ConnectivityResult.wifi) {
          } else {
            _showDialog();
          }
        });
      } catch (e) {}
    });
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('No internet connection'),
        content: Text('Please turn on your network connection to continue'),
        actions: <Widget>[
          FlatButton(
            child: Text('Settings'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: AuthService().userAuthState,
      child: MaterialApp(
        title: 'Our Heroes',
        debugShowCheckedModeBanner: false,
        home: initScreen == 0 || initScreen == null
            ? OnboardingScreen()
            : Wrapper(),
      ),
    );
  }
}
