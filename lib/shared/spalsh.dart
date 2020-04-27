import 'dart:async';

import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 100.0),
              child: Image.asset('assets/images/hero_image.png'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60.0),
            ),
            Text("Onbording Heroes", style: TextStyle(fontSize: 20.0, color: Colors.white)),
            Padding(padding: EdgeInsets.only(top: 20.0),),
            CircularProgressIndicator(
              backgroundColor: Colors.white
              
            )
          ]
        )
      ),
    );
  }
}