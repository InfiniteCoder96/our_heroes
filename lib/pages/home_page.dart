import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/heroDetailScreen.dart';
import 'package:our_heroes/screens/home/settings.dart';
import 'package:our_heroes/services/hero.dart';
import 'package:our_heroes/shared/loading.dart';
import 'package:our_heroes/widgets/hero_list.dart';
import 'package:our_heroes/widgets/home_top_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HeroService _hero = HeroService();
  QuerySnapshot heroes;

  @override
  void initState() {
    _hero.getHeroes().then((results) {
      setState(() {
        heroes = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 150.0,
              child: Settings(),
            );
          });
      super.initState();
    }

    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      // monitor network fetch
      _hero.getHeroes().then((results) {
        setState(() {
          heroes = results;
        });
      });
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use loadFailed(),if no data return,use LoadNodata()
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    }

    return Scaffold(
        backgroundColor: Colors.grey[700],
        body: Container(
          padding: EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[
              HomeTopInfo(),
              Expanded(
                child: Container(
                  child: 
                    HeroList(heroes: heroes)
                  
                ),
              ),
            ],
          ),
        ));
  }
}
