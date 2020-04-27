import 'package:flutter/material.dart';
import 'package:our_heroes/models/user.dart'; 
import 'package:our_heroes/screens/auth/authenticate.dart';
import 'package:our_heroes/shared/spalsh.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context){

    final user = Provider.of<User>(context);

    // return either Home or Authenticate widget
    if(user == null){
      return Authenticate();
    }
    else{
      return SplashScreen();
    }
  }
}