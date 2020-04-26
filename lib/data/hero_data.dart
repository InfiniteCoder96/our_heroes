import 'package:flutter/material.dart';
import '../models/hero.dart';
import '../services/hero.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeroData extends StatefulWidget {
  @override
  _HeroDataState createState() => _HeroDataState();
}

class _HeroDataState extends State<HeroData> {
  
  List<Heroo> hero_data;

  final HeroService _hero = HeroService();
  QuerySnapshot heroes;

  @override
  void initState() {
    _hero.getHeroes().then((results){
      setState(() {
        heroes = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
