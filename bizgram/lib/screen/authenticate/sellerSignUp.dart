import 'package:bizgram/constants/UIconstants.dart';
import 'package:bizgram/screen/home/MainScreen.dart';
import 'package:bizgram/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bizgram/services/auth.dart';
import 'package:bizgram/screen/shared/loading.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SellerSignUp extends StatefulWidget {
  const SellerSignUp({ Key? key }) : super(key: key);

  @override
  _SellerSignUpState createState() => _SellerSignUpState();
}

class _SellerSignUpState extends State<SellerSignUp> {
    Color primary = Color.fromRGBO(245, 245, 220, 20);
  Color secondary = Color.fromRGBO(255, 218, 185, 20);
  Color logo = Color.fromRGBO(128, 117, 90, 60);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("HELLO",style: TextStyle(color: Colors.black, fontSize: 28),),
              Text(".",style: TextStyle(color: logo,fontSize: 28),)
            ],
          ),
          SizedBox(height: UIConstants.fitToHeight(20, context),),
          
        ],
      ),
      
    );
  }
}