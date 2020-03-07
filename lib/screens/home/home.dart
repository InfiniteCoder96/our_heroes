import 'package:flutter/material.dart';
import 'package:our_heroes/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF00796B),
      appBar: new AppBar(
        title: Text('Our Heroes'),
        backgroundColor: Colors.teal[900],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.SignOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 30.0,
            ),
            label: Text(
              'logout',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            
          )
        ],
      ),
    );
  }
}