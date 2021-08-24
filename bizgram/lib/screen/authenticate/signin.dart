import 'package:bizgram/constants/UIconstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color primary= Color.fromRGBO(245, 245, 220, 20);
  Color secondary = Color.fromRGBO(255, 218, 185, 20);
  Color logo = Color.fromRGBO(128,117,90,60);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth firebaseAuth= FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
   Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: primary,
        body: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign in and support small businesses!',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.black, fontSize: 28),
                ),
                SizedBox(height: UIConstants.fitToHeight(20, context)),
                Text(
                  'Enter your email and password below',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.black, fontSize: 14),
                ),
                SizedBox(
                  height: UIConstants.fitToHeight(50, context),
                ),
                _buildTextField(
                    nameController, Icons.account_circle, 'Username'),
                SizedBox(height: UIConstants.fitToHeight(20, context)),
                _buildTextField(passwordController, Icons.lock, 'Password'),
                SizedBox(height: UIConstants.fitToHeight(30, context)),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: UIConstants.fitToHeight(50, context),
                  onPressed: () {},
                  color: logo,
                  child: Text('Login',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  textColor: Colors.black,
                ),
                SizedBox(height: UIConstants.fitToHeight(20, context)),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: UIConstants.fitToHeight(50, context),
                  onPressed: ()  async {
                   
                final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                if(googleUser != null){
                final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                
                final AuthCredential credential = GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
                  final User? user = (await firebaseAuth.signInWithCredential(credential)).user;
                }}
                   ,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.google),
                      SizedBox(width: 10),
                      Text('Sign-in using Google',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ],
                  ),
                  textColor: Colors.black,
                ),
                SizedBox(height: UIConstants.fitToHeight(100, context)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFooterLogo(),
                )
              ],
            ),
          ),
        ));
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('BiZgram',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
 
  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondary, border: Border.all(color: Colors.blue)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black),
            icon: Icon(
              icon,
              color: Colors.black,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }
}