import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:our_heroes/models/user.dart';
import 'package:our_heroes/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

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

    final user = Provider.of<User>(context);

    _saveDeviceToken() async {

      _fcm.subscribeToTopic('heroes');
      
      String token = await _fcm.getToken();

      if (token != null) {
        var tokenRef = _db
            .collection('users')
            .document(user.uid)
            .collection('tokens')
            .document(token);

        await tokenRef.setData({
          'token': token,
          'CreatedAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem
        });
      }
    }

    _saveDeviceToken();
    
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