import 'package:bizgram/constants/UIconstants.dart';
import 'package:bizgram/screen/authenticate/phone_signin.dart';
import 'package:bizgram/services/AddBuyer.dart';
import 'package:bizgram/services/auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bizgram/models/buyer.dart';

import '../wrapper.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class BuyerSlots extends StatefulWidget {
  static const routeName = '78';
  @override
  _BuyerSlotsState createState() => _BuyerSlotsState();
}

//TODO: beautify screen a bit more
//TODO: add loading widget when uploading data
//TODO: add separate screen for seller and buyer sign up and then change userPrivileages() in authservice class
class _BuyerSlotsState extends State<BuyerSlots> {
  Color primary = Color.fromRGBO(245, 245, 220, 20);
  Color secondary = Color.fromRGBO(255, 218, 185, 20);
  Color logo = Color.fromRGBO(128, 117, 90, 60);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _emailIDController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  final _passwordController = TextEditingController();
  late String phone;
  bool showLoading = false;

  //final List<File?> _productPic = [];

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: primary,
      body: new Card(
        color: primary,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10.0,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  "Hello there, Sign Up to buy amazing products!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text("Tell us more about you!",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                //display name
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter a Valid Name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                //email id field
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Email ID',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _emailIDController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains("@") ||
                            !value.contains(".com")) {
                          return 'Please Enter a Valid email id';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                //password field
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 8) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                //address
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10, left: 10, right: 10),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.description_sharp)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter a valid address';
                        }
                        return null;
                      },
                      controller: _addressController,
                    ),
                  ),
                ),

                //contact number
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, right: 10, left: 10, bottom: 10),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: IntlPhoneField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onChanged: (phoneNumber) {
                          setState(() {
                            phone = phoneNumber.countryCode! + " ";
                            phone += phoneNumber.number!;
                          });
                          // onCountryChanged:
                          // (phoneNumber) {
                          //   print('Country code changed to: ' +
                          //       phoneNumber.countryCode.toString());
                          // };
                        }),
                  ),
                ),
                //create event button and cancel buttom
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //back button
                      ElevatedButton(
                        onPressed: () async {
                          // CollectionReference users =
                          //     FirebaseFirestore.instance.collection('users');
                          // CollectionReference buyers =
                          //     FirebaseFirestore.instance.collection('users');
                          // //delete in users
                          // users
                          //     .doc(uid)
                          //     .delete()
                          //     .then((value) => print("User Deleted"))
                          //     .catchError((error) =>
                          //         print("Failed to delete user: $error"));
                          // //delete in sellers
                          // buyers
                          //     .doc(uid)
                          //     .delete()
                          //     .then((value) => print("User Deleted"))
                          //     .catchError((error) =>
                          //         print("Failed to delete user: $error"));

                          // //delete user from firebase auth
                          // try {
                          //   await FirebaseAuth.instance.currentUser!.delete();
                          // } on FirebaseAuthException catch (e) {
                          //   if (e.code == 'requires-recent-login') {
                          //     print(
                          //         'The user must reauthenticate before this operation can be executed.');
                          //   }
                          // }
                          Navigator.pop(context);
                        },
                        child: Text('Back'),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0.00)),
                      ),

                      //clear field button
                      TextButton(
                        onPressed: _clearFields,
                        child: Text('Clear Fields'),
                      ),

                      //next button
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.00),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: secondary,
                                  content: Container(
                                    height:
                                        UIConstants.fitToHeight(100, context),
                                    child: PhoneSignIn(
                                        phoneNumber: phone,
                                        displayName: _nameController.text,
                                        email: _emailIDController.text,
                                        password: _passwordController.text),
                                  ),
                                );
                              });

                          /// This method is used to login the user
                          /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
                          /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
                          try {
                            //FirebaseAuth.instance.signInWithPhoneNumber(_phoneController.text);
                            //var user = await _auth.signInWithCredential(this._phoneAuthCredential);
                            var user = await AuthService()
                                .registerWithEmailAndPassword(
                                    _emailIDController.text,
                                    _passwordController.text);

                            if (user == null) {
                              setState(() {
                                //loading = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Something went wrong"),
                                  ),
                                );
                                print('Something went wrong');
                              });
                            } else {
                              setState(() {
                                //loading = false;
                                print("Signed In");
                              });

                              await FirebaseAuth.instance.currentUser!
                                  .updateDisplayName(_nameController.text);
                              //await FirebaseAuth.instance.currentUser!.updateEmail(widget.email);
                              await FirebaseAuth.instance.currentUser!
                                  .linkWithPhoneNumber(phone);
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => Wrapper(
                              //       showSignUp: false,
                              //     ),
                              //   ),
                              // );
                            }
                          } catch (e) {
                            _handleError(e);
                          }
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((user) async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate() &&
                                user != null) {
                              // If the form is valid, display a snackbar

                              ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(content: Text('Uploading Data')));

                              BuyerData buyer = new BuyerData(
                                uid: uid,
                                displayName: _nameController.text,
                                address: _addressController.text,
                                countryCode: _countryCodeController.text,
                                emailID: _emailIDController.text,
                                password: _passwordController.text,
                                phoneNumber: _phoneNumberController.text,
                              );

                              await UpdateBuyer(buyers: buyer).update().then(
                                  (_) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text('Updated Doc'),
                                  ),
                                );

                                AuthService().buyerPrivileges(user);

                                //go back to wrapper
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Wrapper(
                                      showSignUp: false,
                                    ),
                                  ),
                                );
                                // Navigator.pop(context);

                                //clear field
                                _clearFields();
                              }, onError: (_) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Something went wrong, please try again.'),
                                  ),
                                );
                              });
                            }
                          });
                        },
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _addressController.clear();
    _countryCodeController.clear();
    _emailIDController.clear();
    _phoneNumberController.clear();
    _passwordController.clear();
  }

  void _handleError(e) {
    print(e.message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${e.message}"),
      ),
    );
    // setState(() {
    //   loading = false;
    //   _reset();
    // });
  }
  // }
  // var url = await uploadTask.then((snapshot) {
  //   return snapshot.ref.getDownloadURL();
  // });

  // Waits till the file is uploaded then stores the download url
  //Uri location = (await uploadTask.future).getDownloadURL();

  //returns the download url

}
