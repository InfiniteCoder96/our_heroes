import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference favHeroCollection = Firestore.instance.collection('fav_heroes');
  final CollectionReference heroCollection = Firestore.instance.collection('heroes');


  Future updateUserData(String heroid) async{
    return await favHeroCollection.document(uid).setData({
      'heroid': heroid
    });
  }

  Future updateHeroData(String name, ) async{
    return await heroCollection.document(uid).setData({
      
      'name': name,
    });
  }
}