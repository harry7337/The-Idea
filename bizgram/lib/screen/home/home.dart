//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:huegahsample/screen/appointments/current_appointments.dart';
import 'package:huegahsample/screen/events/events.dart';
import 'package:huegahsample/screen/wrapper.dart';
import 'package:huegahsample/services/auth.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final DateTime today = DateTime.now();
  dynamic result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: MorphingAppBar(
        title: Text('Huegah'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Wrapper(),
                ),
              );
            },
            icon: Icon(Icons.person),
            label: Text('Logout'),
          ),

          //Current bookings
          FlatButton.icon(
            onPressed: () => Navigator.push(
              context,
              SwipeablePageRoute(
                builder: (context) => CurrentBookings(),
                canOnlySwipeFromEdge: true,
              ),
            ),
            icon: Icon(Icons.assignment_sharp),
            label: Text(
              'Bookings',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              child: Text('Events'),
              onPressed: () {
                Navigator.push<void>(
                  context,
                  SwipeablePageRoute(
                    builder: (_) => Events(),
                    canOnlySwipeFromEdge: true,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      /*
      Center(
        child: ElevatedButton(
          child: Text('Events'),
          onPressed: () {
            Navigator.push<void>(
              context,
              SwipeablePageRoute(
                builder: (_) => Events(),
                canOnlySwipeFromEdge: true,
              ),
            );
          },
        ),
      ),
      */
    );
  }
}
