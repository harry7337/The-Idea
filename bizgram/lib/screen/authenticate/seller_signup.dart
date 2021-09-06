import 'dart:io';
import 'package:bizgram/constants/UIconstants.dart';
import 'package:bizgram/screen/home/getting_started.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:bizgram/models/seller.dart';
import 'package:bizgram/services/update_doc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class AddSlots extends StatefulWidget {
  @override
  _AddSlotsState createState() => _AddSlotsState();
}


//TODO: beautify screen a bit more
//TODO: add loading widget when uploading data
//TODO: add separate screen for seller and buyer sign up and then change userPrivileages() in authservice class
class _AddSlotsState extends State<AddSlots> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
   Color primary = Color.fromRGBO(245, 245, 220, 20);
  Color secondary = Color.fromRGBO(255, 218, 185, 20);
  Color logo = Color.fromRGBO(128, 117, 90, 60);
  late String verId;
  bool codeSent = false;
  int resendToken = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final emailID = FirebaseAuth.instance.currentUser!.email;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _emailIDController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _panNumberController = TextEditingController();
  final otpController = TextEditingController();
  var _aadharPic;
  var _productPic;
  var _cod;
  var _worldwide;
  late String verificationId;
  late String phone;
  bool showLoading = false;
      Future<void> verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          final snackBar = SnackBar(content: Text("Login Success"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        verificationFailed: (FirebaseAuthException e) {
          final snackBar = SnackBar(content: Text("${e.message}"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeSent: (String verficationId, int? resendToken) {
          setState(() {
            codeSent = true;
            verId = verficationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verId = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }

  Future<void> verifyPin(String pin) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: pin);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final snackBar = SnackBar(content: Text("Login Success"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  
  //final List<File?> _productPic = [];

  DateTime selectedDate = DateTime.now();
  

  List<DropdownMenuItem<bool>>? get codOptions {
    return [
      DropdownMenuItem(
        child: Text('Yes'),
        value: true,
      ),
      DropdownMenuItem(
        child: Text('No'),
        value: false,
      ),
    ];
  }
  

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
                Text("Hello there, lil entrepenaur!",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
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
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, right: 10, left: 10, bottom: 10),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _panNumberController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Pan Number',
                          prefixIcon: Icon(Icons.person_add)),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 10) {
                          return 'Please Enter a Valid Pan Number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
    
                //upload aadhar image
                //TODO: handle error when pic is not selected
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Upload Aadhar Image',
                        prefixIcon: Icon(Icons.image),
                       
                        //hintText: _aadharPic != null ? "aadhar.jpg" : " ",
                      ),
                      onTap: () async {
                        //Get the file from the image picker and store it
                        final image =
                            await _picker.getImage(source: ImageSource.gallery);
                        final File file = File(image!.path);
                        _aadharPic = file;
                      },
                      readOnly: true,
                      validator: (value) {
                        if(value == null)
                        return "We request you to submit your adhar card";
                        else return null;
                      }
                    ),
                  ),
                ),
    
                //upload product image(s)
                //TODO: handle error when pic is not selected
                //TODO: add functionality to select multiple pictures
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Upload Product Pictures',
                        prefixIcon: Icon(Icons.image),
                        //.hintText: _productPic != null ? "productPic.jpg" : " ",
                      ),
                      onTap: () async {
                        //Get the file from the image picker and store it
                        final image =
                            await _picker.getImage(source: ImageSource.gallery);
                        final File file = File(image!.path);
                        _productPic = file;
                        
                      },
                      readOnly: true,
                      validator: (value) {
                        if(value == null)
                        return "We request you to submit a product picture";
                        else return null;
                      }
                    ),
                  ),
                ),
    
                //cod
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, right: 10, left: 10, bottom: 10),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: DropdownButtonFormField<bool>(
                      items: codOptions,
                      icon: Icon(Icons.delivery_dining),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'COD?',
                      ),
                      onChanged: (cod) {
                        _cod = cod;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please Select a valid option';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
    
                //worldwide
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, right: 10, left: 10, bottom: 10),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: DropdownButtonFormField<bool>(
                      items: codOptions,
                      icon: Icon(Icons.local_shipping_outlined),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Worldwide Shipping?',
                      ),
                      onChanged: (ww) {
                        _worldwide = ww;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please Select a valid option';
                        }
                        return null;
                      },
                    ),
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
                          CollectionReference users =
                              FirebaseFirestore.instance.collection('users');
                          CollectionReference sellers =
                              FirebaseFirestore.instance.collection('users');
                          //delete in users
                          users
                              .doc(uid)
                              .delete()
                              .then((value) => print("User Deleted"))
                              .catchError((error) =>
                                  print("Failed to delete user: $error"));
                          //delete in sellers
                          sellers
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
                                                  verifyPin(pin);
                                                                                  } ,
                                                      ),
                                                      SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  verifyPhone();
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
                            await uploadPic();
                            Seller seller = new Seller(
                                uid: uid,
                                displayName: _nameController.text,
                                address: _addressController.text,
                                countryCode: _countryCodeController.text,
                                emailID: emailID,
                                phoneNumber: _phoneNumberController.text,
                                aadhar: _aadharPic,
                                panNumber: _panNumberController.text,
                                productPic: [_productPic],
                                COD: _cod,
                                worldwide: _worldwide);
    
                            await UpdateDoc(seller: seller).update().then((_) {
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
    _panNumberController.clear();
  }

  Future uploadPic() async {
    //File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final firebase_storage.Reference aadharRef =
        firebase_storage.FirebaseStorage.instance.ref('Images/$uid/aadhar.jpg');

    //Upload the file to firebase
    if (_aadharPic != null) {
      var uploadAadharTask = aadharRef.putFile(_aadharPic);

      try {
        // Storage tasks function as a Delegating Future so we can await them.
        var aadharSnapshot = await uploadAadharTask;

        var progress =
            aadharSnapshot.bytesTransferred * 100.0 / aadharSnapshot.totalBytes;
        print('Uploaded $progress bytes.');
        if (progress == 100.00)
          // ignore: deprecated_member_use
          print('Uploaded Aadhar');
      } on FirebaseException catch (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        print(uploadAadharTask.snapshot);

        print(e.toString());
      }
    }
    //for when _productPic is a list
    // for (File? pic in _productPic) {
    if (_productPic != null) {
      final firebase_storage.Reference productRef = firebase_storage
          .FirebaseStorage.instance
          .ref('Images/$uid/productPic.jpg');
      var uploadProductTask = productRef.putFile(_productPic);
      try {
        var productSnapshot = await uploadProductTask;

        var productProgress = productSnapshot.bytesTransferred *
            100.0 /
            productSnapshot.totalBytes;
        print('Uploaded $productProgress bytes.');
        if (productProgress == 100.00)
          // ignore: deprecated_member_use
          print('Uploaded Product Pics');
      } on FirebaseException catch (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        print(uploadProductTask.snapshot);

        print(e.toString());
        
      }
      //   }
      // }
      // var url = await uploadTask.then((snapshot) {
      //   return snapshot.ref.getDownloadURL();
      // });

      // Waits till the file is uploaded then stores the download url
      //Uri location = (await uploadTask.future).getDownloadURL();

      //returns the download url
      
   
  }
}
   }
   