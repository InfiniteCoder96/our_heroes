import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:our_heroes/screens/wrapper.dart';
import 'package:our_heroes/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_heroes/shared/loading.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  AuthService _auth = AuthService();
  File userImage;
  DocumentSnapshot user;
  bool userImageAvailable = false;
  bool loading = true;
  bool _loading = false;
  var userImageFir;

  @override
  void initState() {
    _auth.getUserDetails().then((results) {
      setState(() {
        user = results;
        loading = false;
      });

      getImage();
      retrieveLostData();
    });
  }

  Future picksImage() async {
    setState(() {
      _loading = false;
    });
    _loading = true;
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      userImage = tempImage;
      userImageAvailable = true;
      _loading = false;
    });
  }

  Future getImage() async {
    var image = user.data['userImage'];

    if (image != null || image != '') {
      setState(() {
        userImageFir = image;
        userImageAvailable = true;
      });
    }
  }

  Future uploadpic(BuildContext context) async {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Updating profile picture...')));

    final StorageReference _storage = FirebaseStorage.instance
        .ref()
        .child('profilepics/${Random(25).nextInt(5000).toString()}.jpg');
    StorageUploadTask _uploadTask = _storage.putFile(userImage);

    StorageTaskSnapshot _taskSnapshot = await _uploadTask.onComplete;

    await _auth.updateCurrentUserDetails(await _storage.getDownloadURL());

    setState(() {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Profile picture updated successfully'),
        backgroundColor: Colors.green,
      ));
      getImage();
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        setState(() {
          userImage = response.file;
        });
      });
    } else {}
  }

  Future<void> _logoutAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes, I am sure'),
              onPressed: () async {
                _auth.SignOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    _logoutAlert();
                                  },
                                  child: Material(
                                    color: Colors.red[900].withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(30.0),
                                    elevation: 8.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 5.0),
                                      child: Icon(
                                        Icons.power_settings_new,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                        ]),
                    SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            picksImage();
                          },
                          child: _loading
                              ? CircularProgressIndicator()
                              : Container(
                                  height: 120.0,
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                      color: Colors.red[900],
                                      borderRadius: BorderRadius.circular(60.0),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5.0,
                                            offset: Offset(0, 4.0),
                                            color: Colors.grey)
                                      ],
                                      image: DecorationImage(
                                          image: userImageAvailable
                                              ? userImage != null
                                                  ? FileImage(userImage)
                                                  : NetworkImage(
                                                      userImageFir)
                                              : AssetImage(
                                                  'assets/images/hero.png'),
                                          fit: BoxFit.cover)),
                                ),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user.data['name'].toString().toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                user.data['email'],
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        height: 25.0,
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.indigo[900]),
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Center(
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                                color: Colors.indigo[900],
                                                fontSize: 16.0),
                                          ),
                                        )),
                                  ),
                                  SizedBox(width: 10.0),
                                  userImage != null
                                      ? GestureDetector(
                                          onTap: () {
                                            
                                            uploadpic(context);
                                            getImage();
                                            userImage = null;
                                            
                                          },
                                          child: Container(
                                              height: 25.0,
                                              width: 70.0,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.yellow[900]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: Center(
                                                child: Text(
                                                  "Save",
                                                  style: TextStyle(
                                                      color: Colors.yellow[900],
                                                      fontSize: 16.0),
                                                ),
                                              )),
                                        )
                                      : Container(),
                                ],
                              ),
                            ])
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 15.0),
                                Text("Email not verified")
                              ],
                            ),
                            Divider(
                                height: 10.0, color: Colors.grey, indent: 5.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.share, color: Colors.grey),
                                SizedBox(width: 15.0),
                                Text("Social media")
                              ],
                            ),
                            Divider(
                                height: 10.0, color: Colors.grey, indent: 5.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.refresh, color: Colors.grey),
                                SizedBox(width: 15.0),
                                Text("Reset password")
                              ],
                            ),
                            Divider(
                                height: 10.0, color: Colors.grey, indent: 5.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.close, color: Colors.red),
                                SizedBox(width: 15.0),
                                Text(
                                  "Deactivate account",
                                  style: TextStyle(color: Colors.red),
                                )
                              ],
                            ),
                          ]),
                        )),
                    SizedBox(height: 20.0),
                    Text(
                      "Notifications",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("App Notification"),
                                Switch(value: true, onChanged: (bool value) {})
                              ],
                            ),
                            Divider(
                                height: 10.0, color: Colors.grey, indent: 5.0),
                          ]),
                        )),
                    SizedBox(height: 20.0),
                    Text(
                      "Other",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Card(
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Language"),
                              ],
                            ),
                          ]),
                        )),
                  ],
                ),
              ),
            ),
          );
  }
}
