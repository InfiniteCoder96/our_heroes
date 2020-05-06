import 'package:flutter/material.dart';
import 'package:our_heroes/widgets/hero_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Container(
          child: HeroList(),
        ));
  }
}
