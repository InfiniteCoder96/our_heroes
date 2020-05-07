import 'package:flutter/material.dart';
import 'package:our_heroes/widgets/hero_list.dart';
import 'package:our_heroes/widgets/search_field.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[700],
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.white, Colors.blueAccent])),
      padding: EdgeInsets.only(top: 30.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(child: HeroList()),
          ),
        ],
      ),
    ));
  }
}
