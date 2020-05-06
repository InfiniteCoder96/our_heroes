import 'dart:io';

import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/heroDetailScreen.dart';
import 'package:our_heroes/services/auth.dart';
import 'package:our_heroes/services/hero.dart';
import 'package:our_heroes/shared/loading.dart';
import 'package:our_heroes/widgets/search_field.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:our_heroes/utilities/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyHerosPage extends StatefulWidget {
  @override
  _MyHerosPageState createState() => _MyHerosPageState();
}

class _MyHerosPageState extends State<MyHerosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  AuthService _auth = AuthService();

  final HeroService _hero = HeroService();
  List<String> heroes;
  List<DocumentSnapshot> heroDetails;

  File newheroImage;

  String heroName;
  String heroDescription;
  String heroShortDescription;
  String heroImage;

  bool loading = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _hero.getAllFavourites().then((results) {
      setState(() {
        heroes = results;
      });

      _hero.getHeroByIds(heroes).then((value) {
        setState(() {
          heroDetails = value;
        });
      });
    });

    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    _hero.getAllFavourites().then((results) {
      setState(() {
        heroes = results;
      });
    });
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<bool> addHeroDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Add a hero',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _showSettingsPanel();
                        },
                        child: Container(
                          height: 120.0,
                          width: 120.0,
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            child: newheroImage != null
                                ? Image.file(
                                    newheroImage,
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
                      SizedBox(height: 25.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        height: 60.0,
                        child: TextFormField(
                          maxLines: 10,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please enter your hero\'s name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() => heroName = value);
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            hintText: 'Enter your hero\'s name',
                            hintStyle: kHintTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        height: 80.0,
                        child: TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please enter short description about your hero ';
                            }
                            return null;
                          },
                          maxLines: 10,
                          onChanged: (value) {
                            setState(() => heroShortDescription = value);
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.text_fields,
                              color: Colors.white,
                            ),
                            hintText: 'Short description about your hero',
                            hintStyle: kHintTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        height: 150.0,
                        child: TextFormField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please enter description about your hero';
                            }
                            return null;
                          },
                          maxLines: 10,
                          onChanged: (value) {
                            setState(() => heroDescription = value);
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              Icons.textsms,
                              color: Colors.white,
                            ),
                            hintText: 'Write about your hero',
                            hintStyle: kHintTextStyle,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      addHero(context);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'))
            ],
          );
        });
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

  Future picksImage(String type) async {
    setState(() {
      loading = true;
    });

    var tempImage;

    if (type == 'gallery')
      tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    else if (type == 'camera')
      tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      newheroImage = tempImage;
      loading = false;
    });
  }

  Future addHero(BuildContext context) async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Onboarding your hero...')));

    Map<String, String> heroData = {
      'heroName': this.heroName,
      'heroDesc': this.heroDescription,
      'heroShrtDesc': this.heroShortDescription,
      'heroImage': this.heroImage
    };

    //await _hero.addHero(heroData);

    DocumentReference docReference =
        await Firestore.instance.collection('heroes').add(heroData);

    var documentId = docReference.documentID;

    var downloadUrl;

    if (newheroImage != null) {
      final StorageReference _storage =
          FirebaseStorage.instance.ref().child('hero_pics/${documentId}_.jpg');

      StorageUploadTask _uploadTask = _storage.putFile(newheroImage);

      StorageTaskSnapshot _taskSnapshot = await _uploadTask.onComplete;
      downloadUrl = await _taskSnapshot.ref.getDownloadURL();
      heroImage = downloadUrl;
    }

    Map<String, String> heroData2 = {'heroImage': downloadUrl};

    //await _hero.addHero(heroData);

    docReference.updateData(heroData2);

    setState(() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Your hero added successfully.'),
        backgroundColor: Colors.green,
      ));
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return heroes == null || heroDetails == null
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: Container(
              padding: EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.blue, Colors.red])),
              child: Column(
                children: [
                  SearchField(),
                  Expanded(
                    child: SmartRefresher(
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: Container(
                          child: Column(children: <Widget>[
                            Expanded(
                                child: GridView.count(
                                    primary: false,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10.0),
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 2,
                                    children: List.generate(
                                        heroes != null ? heroes.length : 0,
                                        (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HeroDetailScreen(
                                                  hero: heroDetails != null
                                                      ? heroDetails
                                                          .elementAt(index)
                                                      : '',
                                                ),
                                              ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                    color: Colors.blueAccent,
                                                    height: 190.0,
                                                    width: 160.0,
                                                    child: heroDetails
                                                                    .elementAt(
                                                                        index)
                                                                    .data[
                                                                'heroImage'] !=
                                                            null
                                                        ? FadeInImage
                                                            .assetNetwork(
                                                            image: heroDetails
                                                                    .elementAt(
                                                                        index)
                                                                    .data[
                                                                'heroImage'],
                                                            placeholder:
                                                                'assets/images/loading.gif',
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/hero.png',
                                                            fit: BoxFit.cover,
                                                          )),
                                                Positioned(
                                                  left: 0.0,
                                                  bottom: 0.0,
                                                  width: 160.0,
                                                  height: 50.0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .bottomCenter,
                                                            end: Alignment
                                                                .topCenter,
                                                            colors: [
                                                          Colors.black,
                                                          Colors.black
                                                              .withOpacity(0.1)
                                                        ])),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 10.0,
                                                  bottom: 10.0,
                                                  right: 10.0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      AutoSizeText(
                                                        heroDetails
                                                            .elementAt(index)
                                                            .data['heroName'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 12.0),
                                                        maxLines: 2,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })))
                          ]),
                        )),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                addHeroDialog(context);
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ));
  }
}
