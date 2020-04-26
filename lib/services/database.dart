import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference favHeroCollection = Firestore.instance.collection('fav_heroes');
  final CollectionReference heroCollection = Firestore.instance.collection('heroes');
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future saveUserData(String name, String email, String userImage) async{
    return await userCollection.document(uid).setData({
      'name': name,
      'email': email,
      'userImage': ''
    });
  }

  Future updateUserData(String userImage) async{
    return await userCollection.document(uid).updateData({
      'userImage': userImage
    });
  }


  Future updateHeroData(String name, ) async{
    return await heroCollection.document(uid).setData({
      'name': name,
    });
  }

  Future getUserDetails(){
    return userCollection.document(this.uid).get();
  }
}