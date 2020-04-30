import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/heroDetailScreen.dart';
import 'package:our_heroes/services/hero.dart';
import 'package:our_heroes/shared/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HeroList extends StatefulWidget {
  final String query;
  HeroList({this.query});

  @override
  _HeroListState createState() => _HeroListState();
}

class _HeroListState extends State<HeroList> {
  final HeroService _hero = HeroService();
  QuerySnapshot heroes;

  void setDe() {}

  @override
  void initState() {
    super.initState();
    _hero.getHeroes(widget.query).then((results) {
      setState(() {
        heroes = results;
      });
    });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    _hero.getHeroes(widget.query).then((results) {
      setState(() {
        heroes = results;
      });
    });
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void filterSearchResults(String query) {}

  @override
  Widget build(BuildContext context) {
    if (heroes != null) {
      return Container(
        child: SmartRefresher(
            enablePullUp: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.builder(
              itemCount: heroes.documents.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
                return Card(
                  elevation: 3.0,
                  color: Colors.blueAccent,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HeroDetailScreen(hero: heroes.documents[i]),
                        ),
                      );
                    },
                    leading: Container(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: heroes.documents[i].data['heroImage'] != null ? FadeInImage.assetNetwork(
                                                      image: heroes.documents[i].data['heroImage'],
                                                      placeholder:
                                                          'assets/images/loading.gif',
                                                    ) : Image.asset(
                          'assets/images/hero.png',
                          fit: BoxFit.cover,
                        ),
                        elevation: 5,
                      ),
                    ),
                    title: Text(
                      heroes.documents[i].data['heroName'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      heroes.documents[i].data['heroShrtDesc'],
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                );
              },
            )),
      );
    } else {
      return Loading();
    }
  }
}
