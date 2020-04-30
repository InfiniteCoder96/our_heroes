import 'package:flutter/material.dart';
import '../models/hero.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeroData extends StatefulWidget {
  @override
  _HeroDataState createState() => _HeroDataState();
}

class _HeroDataState extends State<HeroData> {
  
  List<Heroo> heroData;

  QuerySnapshot heroes;


  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
