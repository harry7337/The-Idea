import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bizgram',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up Page'),
        ),
        body: Center(
          child: Text(
            'You have pushed the button this many times:',
          ),
        ),
      ),
    );
  }
}
