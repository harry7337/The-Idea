import 'package:flutter/material.dart';
import './signin.dart';
import 'package:bizgram/screen/authenticate/signin.dart';
import 'signup.dart';

class Authenticate extends StatefulWidget {
  bool showSignUp;
  Authenticate(this.showSignUp);
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //bool showSignUp = true;
  void toggleView() {
    setState(() {
      widget.showSignUp = !widget.showSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.showSignUp
          ? Register(
              toggleViewParameter: toggleView,
            )
          : LoginScreen(
              toggleViewParameter: toggleView,
            ),
    );
  }
}