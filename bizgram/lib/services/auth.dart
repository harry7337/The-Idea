import 'package:bizgram/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huegahsample/screen/wrapper.dart';
//import 'package:huegahsample/models/user.dart';

class AuthService {
  //create user object based on firebase user
  /*
  User _userFromFireBaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
  */

  //auth change user screen

  User getUser({User user}) {
    FirebaseAuth.instance.authStateChanges().listen(
      (User user) {
        user = null;
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('According to auth we are signed in!');
        }
      },
    );
    //print("$user");
    return user;
  }

  /*
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFireBaseUser(user));
  }
  */

  //sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    User user;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future registerWithEmailAndPassword(String email, String password) async {
    User user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      return user;

      //FirebaseUser user = result.user;
      //return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
      //return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Signed Out");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
