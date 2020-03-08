import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/settings.dart';
import 'package:our_heroes/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context){

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          height: 150.0,
          padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Settings(),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text('Our Heroes'),
        backgroundColor: Color(0xFF398AE5),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () => _showSettingsPanel(),
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            label: Text(
              ''
            ),
            
          )
        ],
      ),
    );
  }
}