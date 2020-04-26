import 'package:flutter/material.dart';

class SearchField extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: Colors.red[900],
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
            hintText: "Search your hero",
            hintStyle: TextStyle(color: Colors.white),
            suffixIcon: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.teal[900],
                child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            border: InputBorder.none
          ),
        ),
      ),
    );
  }
}

