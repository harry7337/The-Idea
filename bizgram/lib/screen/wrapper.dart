import 'package:bizgram/screen/authenticate/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './authenticate/signin.dart';
import 'home/MainScreen.dart';
import '../services/auth.dart';
import './shared/loading.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/wrapper';
  final _auth = AuthService();
  final bool showSignUp;
  Wrapper({required this.showSignUp});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            print("Not Null");
            //_auth.sellerPrivileges(snapshot.data as User);

            return MainScreen();
          } else {
            print("Null User");
            return Authenticate(showSignUp);
          }
        }
        //snapshot.connectionState==ConnectionState.waiting
        return Loading();
      },
    );
  }
}
