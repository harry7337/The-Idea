import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const routeName = './';
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final users = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  var isSeller;
  @override
  void initState() async {
    super.initState();
    isSeller = await users.get().then<bool>((value) => value.data()!['roles']);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: isSeller == null
                ? Text('Welcome ${isSeller ? 'Seller' : 'Buyer'}')
                : Text('Welcome Guest'),
          ),
        ),
      ),
    );
  }
}
