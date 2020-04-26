import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/heroDetailScreen.dart';
import 'package:our_heroes/shared/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HeroList extends StatelessWidget {

  final QuerySnapshot heroes;

  HeroList({this.heroes});

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }
  

  @override
  Widget build(BuildContext context) {
    if(heroes != null){
      return Container(
        child: SmartRefresher(
          enablePullUp: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child:ListView.builder(
          itemCount: heroes.documents.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, i){
            return Card(
              elevation: 3.0,
              color: Colors.blueAccent,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeroDetailScreen(hero: heroes.documents[i]),
                    ),
                  );
                },
                leading: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.deepOrangeAccent,
                  backgroundImage: AssetImage("assets/images/hero.png"),
                ),
                title: Text(heroes.documents[i].data['heroName']),
                subtitle: Text(heroes.documents[i].data['heroDesc']),
                trailing: Icon(Icons.explore),
                
                
              ),
            
            );
          },
        )
        ),
      );
    }
    else{
      return Loading();
    }
  }


}