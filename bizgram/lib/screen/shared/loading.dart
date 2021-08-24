import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(100),
      child: Center(
        child: SpinKitWave(
          color: Theme.of(context).accentColor,
          size: 50,
        ),
      ),
    );
  }
}
