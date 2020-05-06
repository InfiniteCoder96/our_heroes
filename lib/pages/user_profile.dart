import 'dart:io';

import 'package:flutter/material.dart';
import 'package:our_heroes/screens/wrapper.dart';
import 'package:our_heroes/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_heroes/shared/loading.dart';
import 'package:our_heroes/utilities/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService _auth = AuthService();
  File userImage;
  DocumentSnapshot user;
  bool userImageAvailable = false;
  bool loading = true;
  bool _loading = false;
  var userImageFir;

  String userName;
  String userEmail;

  var userNameFir;
  var userEmailFir;

  bool turnOnNotification = false;

  @override
  void initState() {
    super.initState();
    _auth.getUserDetails().then((results) {
      setState(() {
        user = results;
        userNameFir = user.data['name'].toString();
        userEmailFir = user.data['email'].toString();

        userName = user.data['name'].toString();
        userEmail = user.data['email'].toString();

        loading = false;
      });
      getImage();
      retrieveLostData();
    });
  }

  Future picksImage(String type) async {
    setState(() {
      _loading = true;
    });

    var tempImage;

    if (type == 'gallery')
      tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    else if (type == 'camera')
      tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      userImage = tempImage;
      userImageAvailable = true;
      _loading = false;
      editUserDetailsDialog(context);
    });
  }

  Future getImage() async {
    String image = user.data['userImage'];

    if (image.isNotEmpty) {
      setState(() {
        userImageFir = image;
        userImageAvailable = true;
      });
    }
  }

  Future updateUserDetails(BuildContext context) async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Updating your details...')));

    var downloadUrl = userImageFir;

    if (userImage != null) {
      final StorageReference _storage = FirebaseStorage.instance
          .ref()
          .child('profilepics/${user.documentID}.jpg');
      StorageUploadTask _uploadTask = _storage.putFile(userImage);

      StorageTaskSnapshot _taskSnapshot = await _uploadTask.onComplete;
      downloadUrl = await _taskSnapshot.ref.getDownloadURL();
      userImageFir = downloadUrl;
    }

    await _auth.updateCurrentUserDetails(userName, userEmail, userImageFir);

    setState(() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Your details updated successfully.'),
        backgroundColor: Colors.green,
      ));
      userImageFir = downloadUrl;
      userNameFir = userName;
      userEmailFir = userEmail;
    });

    Navigator.of(context).pop();
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
                _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Wrapper()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deactivate Account Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want deactivate?'),
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
                _auth.deleteUserDetails();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Wrapper()));
              },
            ),
          ],
        );
      },
    );
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150.0,
            child: Container(
                color: Colors.indigo[900],
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                child: GridView.count(crossAxisCount: 2, children: [
                  GestureDetector(
                    onTap: () {
                      picksImage('camera');
                      Navigator.of(context).pop();
                    },
                    child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/camera.png'),
                                    fit: BoxFit.cover),
                              ),
                            )),
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "Camera",
                                  style: TextStyle(fontSize: 13.0),
                                )),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      picksImage('gallery');
                      Navigator.of(context).pop();
                    },
                    child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/gallery.png'),
                                    fit: BoxFit.fill),
                              ),
                            )),
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "Gallery",
                                  style: TextStyle(fontSize: 13.0),
                                )),
                          ],
                        )),
                  )
                ])),
          );
        });
    super.initState();
  }

  Future<bool> editUserDetailsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Update details',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _showSettingsPanel();
                    },
                    child: _loading
                        ? CircularProgressIndicator()
                        : Container(
                            height: 120.0,
                            width: 120.0,
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60)),
                              child: userImageAvailable
                                  ? (userImage != null)
                                      ? Image.file(
                                          userImage,
                                          fit: BoxFit.cover,
                                        )
                                      : FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/images/loading.gif',
                                          image: userImageFir,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.asset(
                                      'assets/images/hero.png',
                                      fit: BoxFit.cover,
                                    ),
                              elevation: 5,
                            ),
                          ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: kBoxDecorationStyle,
                    height: 40.0,
                    child: TextFormField(
                      maxLines: 10,
                      onChanged: (value) {
                        setState(() => userName = value);
                      },
                      initialValue: userNameFir,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(5.0),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        hintText: 'Enter your name',
                        hintStyle: kHintTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: kBoxDecorationStyle,
                    height: 40.0,
                    child: TextFormField(
                      maxLines: 10,
                      onChanged: (value) {
                        setState(() => userEmail = value);
                      },
                      initialValue: userEmailFir,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 12.0),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        hintText: 'Enter your email',
                        hintStyle: kHintTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    updateUserDetails(context);
                  },
                  child: Text('Update')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
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
                            _showSettingsPanel();
                          },
                          child: _loading
                              ? CircularProgressIndicator()
                              : Container(
                                  height: 120.0,
                                  width: 120.0,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: userImageAvailable
                                        ? (userImage != null)
                                            ? Image.file(
                                                userImage,
                                                fit: BoxFit.cover,
                                              )
                                            : FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/images/loading.gif',
                                                image: userImageFir,
                                                fit: BoxFit.cover,
                                              )
                                        : Image.asset(
                                            'assets/images/hero.png',
                                            fit: BoxFit.cover,
                                          ),
                                    elevation: 5,
                                  ),
                                ),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                userNameFir.toString().toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              AutoSizeText(
                                userEmailFir.toString(),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      editUserDetailsDialog(context);
                                    },
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
                                            updateUserDetails(context);
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
                                new GestureDetector(
                                  onTap: () {
                                    _deleteAlert();
                                  },
                                  child: Text(
                                    "Deactivate account",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
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
                                Switch(
                                    value: turnOnNotification,
                                    onChanged: (bool value) {
                                      setState(() {
                                        turnOnNotification = value;
                                      });

                                      if (value == true) {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'App notifications activated successfully.'),
                                          backgroundColor: Colors.green,
                                        ));
                                      } else {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'App notifications deactivated successfully.'),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                    })
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
