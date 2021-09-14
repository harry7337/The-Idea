import 'package:bizgram/screen/authenticate/buyer_signup.dart';
import 'package:bizgram/screen/authenticate/seller_signup.dart';
import 'package:bizgram/screen/authenticate/signin.dart';
import 'package:bizgram/screen/authenticate/signup.dart';
import 'package:bizgram/screen/home/getting_started.dart';
import 'package:bizgram/screen/wrapper.dart';
import 'package:flutter/material.dart';
import './screen/home/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/UIconstants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bizgram',
      home: Home(),
      routes: {
        MainScreen.routeName: (ctx) => MainScreen(),
        Wrapper.routeName: (ctx) => Wrapper(
              showSignUp: true,
            ),
        BuyerSlots.routeName: (ctx) => BuyerSlots(),
        AddSlots.routeName: (ctx) => AddSlots(),

      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color primary = Color.fromRGBO(245, 245, 220, 20);
  Color secondary = Color.fromRGBO(255, 218, 185, 20);
  Color logo = Color.fromRGBO(128, 117, 90, 60);
  @override
  Widget build(BuildContext context) {
    return GettingStartedScreen();
  }
}
