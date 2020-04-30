import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:our_heroes/screens/user/profile.dart';
import 'package:our_heroes/services/auth.dart';
import 'package:our_heroes/services/hero.dart';
import 'package:our_heroes/utilities/styles.dart';

class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => _SettingsState();

}

class _SettingsState extends State<Settings>{

  final AuthService _auth = AuthService();
  final HeroService _hero = HeroService();

  String heroName;
  String heroDescription;

  bool loading = false;

  Future<bool> dialogTrigger(BuildContext context) async{
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Hero Added', style: TextStyle(fontSize: 15.0),),
          content: Icon(
              Icons.check,
              color: Colors.green,
            ),
        );
      }
    );
  }

  Future<bool> addHeroDialog(BuildContext context) async{
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a hero', style: TextStyle(fontSize: 15.0),),
          content: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle,
                height: 60.0,
                child: TextField(
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() => heroName = value);

                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.text_fields,
                      color: Colors.white,
                    ),
                    hintText: 'Enter your hero\'s name',
                    hintStyle: kHintTextStyle,
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle,
                height: 150.0,
                child: TextField(
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() => heroDescription = value);

                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.textsms,
                      color: Colors.white,
                    ),
                    hintText: 'Write about your hero',
                    hintStyle: kHintTextStyle,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {

                setState(() => loading = true);

                Navigator.of(context).pop();
                Map<String, String> heroData = {'heroName': this.heroName, 'heroDesc': this.heroDescription};
                _hero.addHero(heroData);
                dialogTrigger(context);
              },
              child: Text('Add')
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.blue[800],
      child: Column(
        children: <Widget>[
          
          FlatButton.icon(
            onPressed: () {
              addHeroDialog(context);
            },
            icon: Icon(
              Icons.person_add,
              color: Colors.white,
              size: 25.0,
            ),
            label: Text(
              'Add a hero',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: 'OpenSans',
              ),
            ),
            
          ),
          FlatButton.icon(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
              size: 25.0,
            ),
            label: Text(
              'My Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: 'OpenSans',
              ),
            ),
            
          ),
          FlatButton.icon(
            
            onPressed: () async {
              Navigator.pop(context);
              _auth.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 25.0,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
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