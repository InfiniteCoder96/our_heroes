import 'package:our_heroes/services/auth.dart';
import 'package:our_heroes/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeroService {
  final String uid;
  HeroService({this.uid});

  final DatabaseService _database = DatabaseService();

  // add a hero
  Future<void> addHero(heroData) async {
    try {
      _database.heroCollection.add(heroData);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getHeroes(query) async {
    if (query != null) {
      return await _database.heroCollection
          .where("heroName", arrayContains: 'you')
          .getDocuments();
    } else {
      return await _database.heroCollection.getDocuments();
    }
  }

  addToFavourites(String documentId) async {
    AuthService authService = AuthService();

    await authService.addToFavourites(documentId);
      
  }

  getFavourites(String documentId) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      //QuerySnapshot cc = await DatabaseService(uid: _user.uid).isFavourite(documentId);

      return await _database.favHeroCollection
          .document(_user.uid).collection(_user.uid)
          .where("heroes", arrayContains: documentId.toString()).getDocuments().then((value){
            if(value.documents.isNotEmpty){
              print('true');
              return true;
            }
            else{
              print('false');
              return false;
            }
          });
  }
}
