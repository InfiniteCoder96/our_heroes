import 'dart:async';

import 'package:flutter/material.dart';
import 'package:our_heroes/models/user.dart';
import 'package:our_heroes/screens/wrapper.dart';
import 'package:our_heroes/services/auth.dart';
import 'package:our_heroes/services/message_handler.dart';
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
  runApp(StreamProvider<User>.value(
      value: AuthService().userAuthState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,home: MyApp())));
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

    MessageHandler();

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

// cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
     
      Scaffold.of(context)
        .showSnackBar(SnackBar(content : Text('You\'re now Connected...'), backgroundColor: Colors.green,));
      
    } 
    else{
       _showDialog();
    }
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
            child: Text('OK, done'),
            onPressed: () {
              Navigator.of(context).pop();
              checkConnectivity();
            },
          ),
          FlatButton(
            child: Text('Go to settings'),
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

    return ((initScreen == 0 || initScreen == null)
            ? OnboardingScreen()
            : Wrapper());
      
    
  } 
  
}
