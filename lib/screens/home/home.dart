import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/heroDetailScreen.dart';
import 'package:our_heroes/screens/home/settings.dart';
import 'package:our_heroes/services/hero.dart';
import 'package:our_heroes/shared/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
  Widget build(BuildContext context){

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          height: 150.0,
          child: Settings(),
        );
      });
      super.initState();
    }

    RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    _hero.getHeroes().then((results){
      setState(() {
        heroes = results;
      });
    });
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(mounted)
    setState(() {

    });
    _refreshController.loadComplete();
  }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text('Our Heroes'),
        backgroundColor: Color(0xFF398AE5),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () => _showSettingsPanel(),
            icon: Icon(
              Icons.offline_bolt,
              color: Colors.white,
              size: 25.0,
              
            ),
            label: Text(
              ''
            ),
            
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _heroList(),
      ) 
    );
  }

  Widget _heroList() {
    if(heroes != null){
      return ListView.builder(
        itemCount: heroes.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i){
          return new Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HeroDetailScreen(hero: heroes.documents[i]),
                  ),
                );
              },
              leading: FlutterLogo(size: 72.0),
              title: Text(heroes.documents[i].data['heroName']),
              subtitle: Text(heroes.documents[i].data['heroDesc']),
              trailing: Icon(Icons.more_vert),
              isThreeLine: true,
            ),
            
          );
        },
      );
    }
    else{
      return Loading();
    }
  }
}