import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/heroDetailScreen.dart';
import 'package:our_heroes/services/hero.dart';
import 'package:our_heroes/shared/loading.dart';
import 'package:our_heroes/widgets/search_field.dart';
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

  Future<void> _deleteAlert(String heroId, int index) async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Hero Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes, I am sure'),
              onPressed: () async {
                await _hero.deleteHeroById(heroId);
                Navigator.of(context).pop(true);
                _onLoading();
              },
            ),
          ],
        );
      },
    );
  }
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
                return Dismissible(
                  key: Key(i.toString()),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _deleteAlert(heroes.documents[i].documentID, i);
                      
                    } else if (direction == DismissDirection.endToStart) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Swipe to right")));
                    }
                    
                  },
                  secondaryBackground:Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.green, Colors.greenAccent])),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                          width: 130.0,
                        ),
                        Text(
                          "Slide to Edit Hero",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0, width: 20.0),
                        Icon(
                          Icons.edit,
                        )
                      ],
                    ),
                  ) ,
                  background: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.red, Colors.redAccent])),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                        ),
                        Text(
                          "Slide to Delete Hero",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0, width: 20.0),
                        Icon(
                          Icons.delete,
                        )
                      ],
                    ),
                  ),
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white70,
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
                      leading: Column(
                        children: <Widget>[
                          Container(
                            width: 50.0,
                            height: 50.0,
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: heroes.documents[i].data['heroImage'] !=
                                      null
                                  ? FadeInImage.assetNetwork(
                                      image:
                                          heroes.documents[i].data['heroImage'],
                                      placeholder: 'assets/images/loading.gif',
                                      fit: BoxFit.fill)
                                  : Image.asset(
                                      'assets/images/hero.png',
                                      fit: BoxFit.cover,
                                    ),
                              elevation: 5,
                            ),
                          )
                        ],
                      ),
                      title: Text(
                        heroes.documents[i].data['heroName'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        heroes.documents[i].data['heroShrtDesc'],
                        style: TextStyle(color: Colors.black, fontSize: 12.0),
                      ),
                      trailing: Icon(Icons.navigate_next),
                    ),
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
