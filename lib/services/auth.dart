import 'package:firebase_auth/firebase_auth.dart';
import 'package:our_heroes/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get userAuthState {
    return _auth.onAuthStateChanged
      //.map((FirebaseUser user) => _userFromFirebaseUser(user))
      .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password

  // sign up with email & password
  Future registerWithEmailandPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e);
      return null;
    }
  }

  // sign out
  Future SignOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e);
      return null;
    }
  }
}