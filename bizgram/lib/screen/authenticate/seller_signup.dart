import 'dart:io';

import 'package:bizgram/models/seller.dart';
import 'package:bizgram/services/update_doc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddSlots extends StatefulWidget {
  @override
  _AddSlotsState createState() => _AddSlotsState();
}

//TODO: beautify screen a bit more
//TODO: add loading widget when uploading data
//TODO: add separate screen for seller and buyer sign up and then change userPrivileages() in authservice class
class _AddSlotsState extends State<AddSlots> {
  final firebase_storage.Reference sref =
      firebase_storage.FirebaseStorage.instance.ref().child('Images');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final emailID = FirebaseAuth.instance.currentUser!.email;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _emailIDController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _panNumberController = TextEditingController();

  var _aadharPic;
  var _productPic;
  var _cod;
  var _worldwide;
  //final List<File?> _productPic = [];

  DateTime selectedDate = DateTime.now();

  List<DropdownMenuItem<bool>>? get codOptions {
    return [
      DropdownMenuItem(
        child: Text('True'),
        value: true,
      ),
      DropdownMenuItem(
        child: Text('False'),
        value: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext ctx) {
    return new Card(
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
              //display name
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.ac_unit_sharp),
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
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
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
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Contact Number',
                        prefixIcon: Icon(Icons.phone),
                        prefixText: '+91'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 10) {
                        return 'Please Enter a Valid Phone Number';
                      }
                      return null;
                    },
                  ),
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
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _panNumberController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Pan Number',
                        prefixIcon: Icon(Icons.phone)),
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
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Upload Aadhar Image',
                      prefixIcon: Icon(Icons.image),
                      hintText: _aadharPic != null ? "aadhar.jpg" : " ",
                    ),
                    onTap: () async {
                      //Get the file from the image picker and store it
                      final image =
                          await _picker.getImage(source: ImageSource.gallery);
                      final File file = File(image!.path);
                      _aadharPic = file;
                    },
                    readOnly: true,
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
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Upload Product Pictures',
                      prefixIcon: Icon(Icons.image),
                      hintText: _productPic != null ? "productPic.jpg" : " ",
                    ),
                    onTap: () async {
                      //Get the file from the image picker and store it
                      final image =
                          await _picker.getImage(source: ImageSource.gallery);
                      final File file = File(image!.path);
                      _productPic = file;
                    },
                    readOnly: true,
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
                      border: Border.all(color: Colors.blue)),
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
                      border: Border.all(color: Colors.blue)),
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
