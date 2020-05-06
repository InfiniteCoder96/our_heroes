import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red])),
      child: Center(
        child: SpinKitCircle(
          color: Colors.red[900],
          size: 50.0,
          duration: Duration(milliseconds: 2000),
        ),
      ),
    );
  }
}
