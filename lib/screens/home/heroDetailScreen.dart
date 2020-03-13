import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeroDetailScreen extends StatefulWidget {

  final DocumentSnapshot hero;

  // In the constructor, require a Todo.
  HeroDetailScreen({Key key, @required this.hero}) : super(key: key);

  @override
  _HeroDetailScreenState createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen> {

  bool _alreadyFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF398AE5),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              _alreadyFav ? Icons.favorite : Icons.favorite_border,
              color: _alreadyFav ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {

                if(_alreadyFav){
                  _alreadyFav = false;
                }
                else{
                  _alreadyFav = true;
                }
                
              });
            },
          )
        ],
      ),

      backgroundColor: Color(0xFF398AE5),
      body: LayoutStarts(hero: widget.hero),
    );
  }
}

class LayoutStarts extends StatelessWidget {

  final DocumentSnapshot hero;

  // In the constructor, require a Todo.
  LayoutStarts({Key key, @required this.hero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        HeroDetailsAnimation(hero: hero),
        CustomBottomSheet(hero: hero)
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
            padding: EdgeInsets.only(left: 30,top: 30,right: 30),
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
        
      ],
    );
  }
}

/* class HeroCarousel extends StatefulWidget {
  @override
  _HeroCarouselState createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {

  static final List<String> imgList = null;

  final List<Widget> child = _map<Widget>(imgList, (index, String assetName){
    return Container(
      child: Image.asset("assets/img/$assetName", fit: BoxFit.fitWidth)
    );
  }).toList();

  static List<T> _map<T>(List list, Function handler){

    List<T> result = [];

    for(var i = 0; i < list.length; i++){
      result.add(handler(i, list[i]));
    }

    return result;
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            height: 250,
            viewportFraction: 1.0,
            items: child,
            onPageChanged: (index){
              setState(() {
                _current = index;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _map<Widget>(imgList, (index, assetName){

                return Container(
                  width: 50,
                  height: 2,
                  decoration: BoxDecoration(
                    color: _current == index ? Colors.grey[100] : Colors.grey[600]
                  )
                );
              }),
              ),
          )
        ],
        ),
    );
  }
} */

class CustomBottomSheet extends StatefulWidget {

  final DocumentSnapshot hero;

  // In the constructor, require a Todo.
  CustomBottomSheet({Key key, @required this.hero}) : super(key: key);

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
        child: SheetContainer(hero: widget.hero),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {

  final DocumentSnapshot hero;

  // In the constructor, require a Todo.
  SheetContainer({Key key, @required this.hero}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double sheetItemHeight = 110;

    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                offerDetails(sheetItemHeight, hero),
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
        color: Color(0xFF73AEF5)
      ),
    );
  }

  offerDetails(double sheetItemHeight, DocumentSnapshot hero){
    return Container(
      padding: EdgeInsets.only(top: 15, left: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Hero's Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize:  16),
                children: [
                  TextSpan(
                    text: hero.data['heroDesc'],
                    style: TextStyle(color: Colors.black)
                  ),
                  
                ]
              ),
            ),
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