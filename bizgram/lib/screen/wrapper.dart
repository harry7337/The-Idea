import 'package:flutter/material.dart';
import 'package:huegahsample/screen/authenticate/authenticate.dart';
import 'package:huegahsample/screen/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser;
  //Wrapper({this.user});

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      print("Not Null");
      return Home();
    } else {
      print("Null User");
      return Authenticate();
    }
  }
}
