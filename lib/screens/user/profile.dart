import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_heroes/services/auth.dart';
import 'package:our_heroes/shared/loading.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  File userImage;
  final AuthService _auth = AuthService();
  DocumentSnapshot user;
  bool userImageAvailable = false;
  bool loading = true;
  
  @override
  void initState() {
   _auth.getUserDetails().then((results){
     
     retrieveLostData();
      getImage();

      setState(() {
        user = results;
        loading = false;
      });
      
    });
    

  }

  Future picksImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      userImage = tempImage;
      userImageAvailable = true;
    });
  }

  Future getImage() async{

    var image = user.data['userImage'];

    if(image != null || image != ''){
      setState(() {
        userImageAvailable = true;
      });
    }
  }

  Future uploadpic(BuildContext context) async {

    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Updating profile picture...')));

    final StorageReference _storage = FirebaseStorage.instance.ref().child('profilepics/${Random(25).nextInt(5000).toString()}.jpg');
    StorageUploadTask _uploadTask = _storage.putFile(userImage);

    StorageTaskSnapshot _taskSnapshot = await _uploadTask.onComplete;

    await _auth.updateCurrentUserDetails( await _storage.getDownloadURL());

    setState(() {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile picture updated successfully'), backgroundColor: Colors.green,));
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response =
        await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        
        setState(() {
          userImage = response.file;
        });
        
      });
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xFF478DE0),
                  child: ClipOval(
                    child: SizedBox(
                      width: 180.0,
                      height: 180.0,
                      child: 
                      userImageAvailable ? (userImage != null) ? Image.file(userImage,fit:BoxFit.fill) : Image.network(user.data['userImage'],fit: BoxFit.fill)
                        :                      
                        Image.network(
                          'https://nextgate.com/wp-content/uploads/2018/10/superheros.png',
                          fit: BoxFit.fill
                        ),
                    ),
              
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    size: 30,
                    
                  ),
                  onPressed: () {
                    picksImage();
                  },
                  color: Color(0xFF398AE5),
                ),
              )
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Username',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(user.data['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          
                        ]
                      ),
                    )
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.edit,
                        color: Colors.lightGreen,
                        size: 22,
                      ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Email',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(user.data['email'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          
                        ]
                      ),
                    )
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.edit,
                        color: Colors.lightGreen,
                        size: 22,
                      ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 4.0,
                    splashColor: Colors.black,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      )
                    ),
                  ),
                  RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      uploadpic(context);
                    },
                    elevation: 4.0,
                    splashColor: Colors.green,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      )
                    ),
                  ),
                ],
              ),
            ],
          )
        )
      ),
    );
  }  
}