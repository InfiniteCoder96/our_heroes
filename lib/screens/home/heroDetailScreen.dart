import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeroDetailScreen extends StatelessWidget {

  final DocumentSnapshot hero;

  // In the constructor, require a Todo.
  HeroDetailScreen({Key key, @required this.hero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        HeroDetailsAnimation(hero: hero),
        CustomBottomSheet()
      ],
    );
  }
}

class HeroDetailsAnimation extends StatefulWidget {

  final DocumentSnapshot hero;
  HeroDetailsAnimation({this.hero});

  @override
  _HeroDetailsAnimationState createState() => _HeroDetailsAnimationState();
}

class _HeroDetailsAnimationState extends State<HeroDetailsAnimation> {
  @override
  Widget build(BuildContext context) {
    return HeroDetails(hero: widget.hero);
  }
}

class HeroDetails extends StatelessWidget {

  final DocumentSnapshot hero;
  HeroDetails({this.hero});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30),
            child: _heroTitle(),
          ),
          Container(
            width: double.infinity,
            
          )
        ],
      ));
  }

  _heroTitle(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.white, fontSize: 38),
            children: [
              TextSpan(text: hero.data['heroName']),
              //TextSpan(text: "\n"),
              //TextSpan(text: hero.data['heroDesc'], style: TextStyle(fontWeight: FontWeight.w700)),
            ]
          )
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize:  16),
            children: [
              TextSpan(
                text: hero.data['heroDesc'],
                style: TextStyle(color: Colors.grey[20])
              ),
              
            ]
          ),
        )
      ],
    );
  }
}

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {

  double sheetTop = 400;
  double minSheetTop = 30;

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: sheetTop,
      left: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded ? sheetTop = 400: sheetTop = minSheetTop;
            isExpanded = !isExpanded;
          });
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double sheetItemHeight = 110;

    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        color: Color(0xfff1f1f1)
      ),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                offerDetails(sheetItemHeight),
                SizedBox(height: 220)
              ]
            ),
          )
        ],
        ),
      
    );
  }

  drawerHandle(){
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xffd9dbdb)
      ),
    );
  }

  offerDetails(double sheetItemHeight){
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        children: <Widget>[
          Text(
            "Offer Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 10
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index){
                return ListItem(
                  sheetItemHeight: sheetItemHeight,

                );
              }
              )
          )
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {

  final double sheetItemHeight;
  final Map mapVal;

  ListItem({
    this.sheetItemHeight,
    this.mapVal
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: sheetItemHeight,
      height: sheetItemHeight,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            mapVal.keys.elementAt(0),
          ],
      ),
    );
  }
}