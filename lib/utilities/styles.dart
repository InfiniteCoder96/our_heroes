import 'package:flutter/material.dart';

final kTitleStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'CM Sans Serif',
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  height: 1.8,
);

final kSubtitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  height: 1.5,
);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

TextStyle listTitleDefaultTextStyle = TextStyle(color: Colors.white70, fontSize: 20.0, fontWeight: FontWeight.w600);
TextStyle listTitleSelectedTextStyle = TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600);

Color selectedColor = Color(0xFF4AC8EA);
Color drawerBackgroundColor = Color(0xFF272D34);