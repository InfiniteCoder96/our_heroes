import 'package:our_heroes/services/database.dart';

class HeroService {

  final DatabaseService _database = DatabaseService();

  // add a hero
  Future<void> addHero(heroData) async {
    try{
      _database.heroCollection.add(heroData);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  getHeroes() async{
    return await _database.heroCollection.getDocuments();
  }
}