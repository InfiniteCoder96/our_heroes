import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:our_heroes/services/auth.dart';

class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => _SettingsState();

}

class _SettingsState extends State<Settings>{

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0
          ),
          FlatButton(
            onPressed: () => print('Forgot Password Button Pressed'),
            padding: EdgeInsets.only(right: 0.0),
            child: Text(
              'My Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          SizedBox(
            height: 10.0
          ),
          FlatButton(
            onPressed: () async {
              Navigator.pop(context);
              _auth.SignOut();
            },
            padding: EdgeInsets.only(right: 0.0),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      ),
    );

  }
}