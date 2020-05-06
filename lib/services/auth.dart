import 'package:firebase_auth/firebase_auth.dart';
import 'package:our_heroes/models/user.dart';
import 'package:our_heroes/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
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
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInUser(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign up with email & password
  Future registerUser(String name, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).saveUserData(name, email, '');

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> googleSignIn() async {
    print("signed in started");
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential autheCredentials = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in access token" + googleAuth.accessToken);
    final AuthResult authResult =
        await _auth.signInWithCredential(autheCredentials);
    final FirebaseUser user = authResult.user;
    updateCurrentUserDetails(user.displayName, user.email, user.photoUrl);
    print("signed in " + user.displayName);
    return user;
  }

  // get user details
  Future getUserDetails() async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      return await DatabaseService(uid: _user.uid).getUserDetails();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future deleteUserDetails() async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      return await _user.delete();
    } catch (e) {
      print(e);
      return null;
    }
  }

  //  get cuurent user
  updateCurrentUserDetails(String name, String email, String userImage) async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      await DatabaseService(uid: _user.uid)
          .updateUserData(name, email, userImage);
    } catch (e) {
      print(e);
      return null;
    }
  }

  addToFavourites(String documentID) async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      await DatabaseService(uid: _user.uid).addToFavourites(documentID);
    } catch (e) {
      print(e);
      return null;
    }
  }

  deleteFromFavourites(String documentID) async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      await DatabaseService(uid: _user.uid).deleteFromFavourites(documentID);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }

  getFavourites(String documentId) async {
    try {} catch (e) {
      print(e);
      return null;
    }
  }
}
