import 'package:bizgram/constants/UIconstants.dart';
import 'package:bizgram/screen/authenticate/signin.dart';
import 'package:bizgram/screen/home/MainScreen.dart';
import 'package:bizgram/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bizgram/services/auth.dart';
import 'package:bizgram/screen/shared/loading.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Register extends StatefulWidget {
   
  static const routeName = './signup';
 

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Color primary = Color.fromRGBO(245, 245, 220, 20);
  Color secondary = Color.fromRGBO(255, 218, 185, 20);
  Color logo = Color.fromRGBO(128, 117, 90, 60);
  bool isHidden = true;
  bool isEmpty = true;
  late String email;
  late String password;
  bool loading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                      'Sign up and support small businesses!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 28),
                    ),
                    SizedBox(height: UIConstants.fitToHeight(20, context)),
                    Text(
                      'Enter your email and password below',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 14),
                    ),
                    SizedBox(
                      height: UIConstants.fitToHeight(50, context),
                    ),

                    //username field
                    emailInputWidget(nameController, "Enter your email id",
                        false, "Email", "email", (value) {
                      email = value;
                    }),
                    SizedBox(height: UIConstants.fitToHeight(20, context)),

                    //pass field
                    passInputWidget(passwordController, "Enter your password",
                        true, "Password", "password", (value) {
                      password = value;
                    }),

                    SizedBox(height: UIConstants.fitToHeight(30, context)),

                    //sign up with email
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: UIConstants.fitToHeight(50, context),
                      onPressed: () => AuthService()
                          .registerWithEmailAndPassword(
                              nameController.text, passwordController.text),
                      color: logo,
                      child: Text('Sign Up',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      textColor: Colors.black,
                    ),
                    SizedBox(height: UIConstants.fitToHeight(20, context)),

                    //sign up with google
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: UIConstants.fitToHeight(50, context),
                      onPressed: () => AuthService().signInWithGoogle(),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.google),
                          SizedBox(width: 10),
                          Text('Sign-up using Google',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                      textColor: Colors.black,
                    ),
                    SizedBox(
                      height: UIConstants.fitToHeight(20, context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            elevation: 0,
                            height: UIConstants.fitToHeight(25, context),
                            color: Colors.blue[200],
                            child: Text(
                              'Skip Sign Up?',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            onPressed: () => Navigator.popAndPushNamed(
                                context, MainScreen.routeName)),
                        MaterialButton(
                          elevation: 0,
                          height: UIConstants.fitToHeight(25, context),
                          color: Colors.blue[200],
                          child: Column(
                            children: [
                              Text(
                                "Already Have an account?",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              Text(
                                "Sign In?",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.of(context).popAndPushNamed(LoginScreen.routeName)
                        )
                      ],
                    ),
                    SizedBox(height: UIConstants.fitToHeight(100, context)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildFooterLogo(),
                    )
                  ],
                ),
              ),
            ),
          );
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

  Widget passInputWidget(
    TextEditingController textEditingController,
    String validation,
    bool,
    String label,
    String hint,
    save,
  ) {
    return TextFormField(
      style: TextStyle(fontSize: 15.0, color: Color(0xff9FA0AD)),
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(225, 193, 110, 20),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
        labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff41414A)),
            borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff41414A)),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff41414A)),
            borderRadius: BorderRadius.circular(12.0)),
        suffix: InkWell(
          onTap: togglePasswordView,
          child: IconTheme(
            data: new IconThemeData(color: Colors.white),
            child: Icon(
              isHidden ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
      obscureText: isHidden,
      validator: (String? value) {
        if (value!.isEmpty) {
          validation:
          null;
        } else
          return null;
      },
      onSaved: save,
    );
  }

  Widget emailInputWidget(TextEditingController textEditingController,
      String validation, bool, String label, String hint, save) {
    return TextFormField(
      style: TextStyle(fontSize: 15.0, color: Color(0xff9FA0AD)),
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(225, 193, 110, 20),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
        labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff41414A)),
            borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff41414A)),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff41414A)),
            borderRadius: BorderRadius.circular(12.0)),
      ),
      obscureText: bool,
      validator: (String? value) {
        if (value!.isEmpty) {
          validation:
          null;
        } else
          return null;
      },
      onSaved: save,
    );
  }

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}
