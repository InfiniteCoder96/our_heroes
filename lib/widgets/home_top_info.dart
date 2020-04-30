import 'package:flutter/material.dart';

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
              child: Column()
            );
          });
    }

    return Container(
          
    );
  }
}
