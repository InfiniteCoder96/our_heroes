import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_heroes/services/hero.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FavHeroDetailScreen extends StatefulWidget {
  final DocumentSnapshot hero;

  FavHeroDetailScreen({Key key, @required this.hero}) : super(key: key);
  @override
  _FavHeroDetailScreenState createState() => _FavHeroDetailScreenState();
}

class _FavHeroDetailScreenState extends State<FavHeroDetailScreen> {
  HeroService heroService = new HeroService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF398AE5),
        elevation: 0.0,
      ),
      // backgroundColor: Color(0xFF398AE5),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.red])),
          child: LayoutStarts(hero: widget.hero)),
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
          padding: EdgeInsets.only(left: 30, top: 30, right: 30),
          child: _heroTitle(),
        ),
        Container(
          width: double.infinity,
        )
      ],
    ));
  }

  _heroTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
            text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                ),
                children: [
              TextSpan(text: hero.data['heroName']),
              //TextSpan(text: "\n"),
              //TextSpan(text: hero.data['heroDesc'], style: TextStyle(fontWeight: FontWeight.w700)),
            ])),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: 250.0,
                  width: 200.0,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0)),
                    child: hero.data['heroImage'] != null
                        ? FadeInImage.assetNetwork(
                            image: hero.data['heroImage'],
                            placeholder: 'assets/images/loading.gif',
                            fit: BoxFit.fill)
                        : Image.asset(
                            'assets/images/hero.png',
                            fit: BoxFit.cover,
                          ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

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
            isExpanded ? sheetTop = 400 : sheetTop = minSheetTop;
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
          color: Colors.white),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(children: <Widget>[
              offerDetails(sheetItemHeight, hero),
              SizedBox(height: 220)
            ]),
          )
        ],
      ),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xFF73AEF5)),
    );
  }

  offerDetails(double sheetItemHeight, DocumentSnapshot hero) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text("Hero's Details",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18)),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: AutoSizeText(hero.data['heroDesc'],
                style: TextStyle(color: Colors.black, fontSize: 20.0)),
          )
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final double sheetItemHeight;
  final Map mapVal;

  ListItem({this.sheetItemHeight, this.mapVal});

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
