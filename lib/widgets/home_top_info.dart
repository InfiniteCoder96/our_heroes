import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/settings.dart';
import 'package:our_heroes/widgets/search_field.dart';

class HomeTopInfo extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 150.0,
              child: Settings(),
            );
          });
    }

    return Container(
          
    );
  }
}
