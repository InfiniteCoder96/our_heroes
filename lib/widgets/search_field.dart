import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  @override
  _SearchFeildState createState() => _SearchFeildState();
}

class _SearchFeildState extends State<SearchField> {
  
  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    editingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    editingController.addListener(() {
      //here you have the changes of your textfield
      print("value: ${editingController.text}");
      //use setState to rebuild the w

      setState(() {
        
      });
      
    });
    super.initState();
  }

  filterSearchResults(query) {
    
    if(query.lenght == 0){
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
      child: Material(
        color: Colors.blueAccent,
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        child: TextField(
          onChanged: (value) {
            
          },
          controller: editingController,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
              hintText: "Search your hero...",
              hintStyle: TextStyle(color: Colors.white),
              suffixIcon: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                child: Icon(
                  Icons.search,
                  color: Colors.blueAccent,
                ),
              ),
              border: InputBorder.none),
        ),
      ),
    );
  }
}
