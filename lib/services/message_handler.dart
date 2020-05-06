import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:our_heroes/models/user.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();

    _fcm.subscribeToTopic('heroes');

    if(Platform.isIOS){

      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) { 
        _saveDeviceToken();
      });
      
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    else{
      _saveDeviceToken();
    }

    /* _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
    ); */
  }

  _saveDeviceToken() async{
    final user = Provider.of<User>(context);

    String token = await _fcm.getToken();

    if(token != null){
      var tokenRef = _db.collection('users').document(user.uid).collection('tokens').document(token);

      await tokenRef.setData({
        'token': token,
        'CreatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}