import 'dart:io';
import 'package:bizgram/constants/UIconstants.dart';
import 'package:bizgram/screen/home/getting_started.dart';
import 'package:bizgram/services/AddBuyer.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:bizgram/models/seller.dart';
import 'package:bizgram/services/update_doc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bizgram/models/buyer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class BuyerGoogleSlots extends StatefulWidget {
  static const routeName = '8';
  @override
  _BuyerGoogleSlotsState createState() => _BuyerGoogleSlotsState();
}


//TODO: beautify screen a bit more
//TODO: add loading widget when uploading data
//TODO: add separate screen for seller and buyer sign up and then change userPrivileages() in authservice class
class _BuyerGoogleSlotsState extends State<BuyerGoogleSlots> {
   Color primary = Color.fromRGBO(245, 245, 220, 20);
  Color secondary = Color.fromRGBO(255, 218, 185, 20);
  Color logo = Color.fromRGBO(128, 117, 90, 60);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final emailID = FirebaseAuth.instance.currentUser?.email;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _emailIDController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  final pass = TextEditingController();
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
                Text("Hello there, Sign Up to buy amazing products!",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                Text("Tell us more about you!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
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
                        labelText: 'Password',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: pass,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 8 ) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                 
                //address
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 10, left: 10, right: 10),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      maxLength: 3,
                      keyboardType: TextInputType.multiline,
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
                //TODO: add country code
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, right: 10, left: 10, bottom: 10),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child:     IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  onChanged: (phoneNumber) {
                      setState(() {
                        phone = phoneNumber.completeNumber;
                      });
                  onCountryChanged: (phoneNumber) {
                    print('Country code changed to: ' + phoneNumber.countryCode.toString());
                  };
                  }),
                  ),
                ),
    
                //pan number
                //TODO: Add pan number check
               
                //upload aadhar image
                //TODO: handle error when pic is not selected
                
                //upload product image(s)
                //TODO: handle error when pic is not selected
                //TODO: add functionality to select multiple pictures
                
                //worldwide
               
                //create event button and cancel buttom
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //back button
                      ElevatedButton(
                        onPressed: () async {
                          CollectionReference users =
                              FirebaseFirestore.instance.collection('users');
                          CollectionReference buyers =
                              FirebaseFirestore.instance.collection('users');
                          //delete in users
                          users
                              .doc(uid)
                              .delete()
                              .then((value) => print("User Deleted"))
                              .catchError((error) =>
                                  print("Failed to delete user: $error"));
                          //delete in sellers
                          buyers
                              .doc(uid)
                              .delete()
                              .then((value) => print("User Deleted"))
                              .catchError((error) =>
                                  print("Failed to delete user: $error"));
    
                          //delete user from firebase auth
                          try {
                            await FirebaseAuth.instance.currentUser!.delete();
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'requires-recent-login') {
                              print(
                                  'The user must reauthenticate before this operation can be executed.');
                            }
                          }
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
                                        height: UIConstants.fitToHeight(
                                            100, context),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Enter the Verification Code",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),),
                                                  OTPTextField(
                                                  length: 6,
                                                  width: MediaQuery.of(context).size.width,
                                                  fieldWidth: 30,
                                                  style: TextStyle(fontSize: 20),
                                                  textFieldAlignment: MainAxisAlignment.spaceAround,
                                                  fieldStyle: FieldStyle.underline,
                                                  onCompleted: (pin) {
                                                  //verifyPin(pin);
                                                                                  } ,
                                                      ),
                                                      SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  //verifyPhone();
                                                },
                                                child: Text("Verify"))

                                            ,
                                
                                          ],
                                        ),
                                      ));
                                      
                                });
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar
    
                            ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text('Uploading Data')));
                            
                            BuyerData buyer = new BuyerData(
                                uid: uid,
                                displayName: _nameController.text,
                                address: _addressController.text,
                                countryCode: _countryCodeController.text,
                                emailID: emailID,
                                password: pass.text,
                                phoneNumber: _phoneNumberController.text,
                            );
    
                            await UpdateBuyer(buyers: buyer).update().then((_) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('Updated Doc'),
                                ),
                              );
                              Navigator.pop(context);
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
    pass.clear();
  }

  
      // }
      // var url = await uploadTask.then((snapshot) {
      //   return snapshot.ref.getDownloadURL();
      // });

      // Waits till the file is uploaded then stores the download url
      //Uri location = (await uploadTask.future).getDownloadURL();

      //returns the download url
      
   
  }

   
   