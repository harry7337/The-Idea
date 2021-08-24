import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const routeName = './';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
