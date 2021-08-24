import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './authenticate/signin.dart';
import 'home/MainScreen.dart';
import '../services/auth.dart';
import './shared/loading.dart';

class Wrapper extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            print("Not Null");
            _auth.userPrivileges(snapshot.data as User);

            return MainScreen();
          } else {
            print("Null User");
            return LoginScreen();
          }
        }
        //snapshot.connectionState==ConnectionState.waiting
        return Loading();
      },
    );
  }
}
