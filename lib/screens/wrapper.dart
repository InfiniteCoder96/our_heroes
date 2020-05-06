import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:our_heroes/models/user.dart';
import 'package:our_heroes/screens/auth/authenticate.dart';
import 'package:our_heroes/shared/spalsh.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Wrapper extends StatelessWidget {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

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

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return SplashScreen();
    }
  }
}
