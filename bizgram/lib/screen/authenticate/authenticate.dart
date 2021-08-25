import 'package:flutter/material.dart';
import './signin.dart';
import 'package:bizgram/screen/authenticate/signin.dart';
import 'SignUp.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignUp = true;
  void toggleView() {
    setState(() {
      showSignUp = !showSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignUp
          ? Register()
                    : LoginScreen()
    );
  }
}
