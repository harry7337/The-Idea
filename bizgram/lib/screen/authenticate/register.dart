import 'package:flutter/material.dart';
import 'package:huegahsample/services/auth.dart';
import 'package:huegahsample/shared/constants.dart';
import 'package:huegahsample/shared/loading.dart';
import 'package:huegahsample/screen/wrapper.dart';

class Register extends StatefulWidget {
  final Function toggleViewParameter;
  Register({this.toggleViewParameter});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  dynamic result;

  //text field state
  String email = '';
  String pass = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign Up to Huegah'),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleViewParameter();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecoration,
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val.length < 6
                            ? 'Enter a password longer than 6 characters'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            pass = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            result = await _auth.registerWithEmailAndPassword(
                                email, pass);
                            if (result == null) {
                              setState(() {
                                error = 'Please enter a valid email';
                                loading = false;
                              });
                            } else {
                              setState(() {
                                loading = false;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Wrapper(),
                                  ),
                                );
                                print("Signed in!");
                              });
                            }
                          }
                        },
                        color: Colors.pink[400],
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }
}
