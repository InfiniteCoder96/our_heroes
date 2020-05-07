import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_heroes/screens/home/heroDetailScreen.dart';
import 'package:our_heroes/services/hero.dart';
import 'package:our_heroes/shared/loading.dart';
import 'package:our_heroes/widgets/search_field.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:our_heroes/utilities/styles.dart';
import 'package:image_picker/image_picker.dart';

class HeroList extends StatefulWidget {
  final String query;
  HeroList({this.query});
  @override
  _HeroListState createState() => _HeroListState();
}

class _HeroListState extends State<HeroList> {
  final HeroService _hero = HeroService();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  QuerySnapshot heroes;
  DocumentSnapshot existingHero;
  bool loading = false;

  String documentID;
  String heroName;
  String heroDescription;
  String heroShortDescription;
  File heroImage;
  var heroImageFir;

  bool heroImageAvailable = false;

  void setDe() {}

  @override
  void initState() {
    super.initState();
    _hero.getHeroes(widget.query).then((results) {
      setState(() {
        heroes = results;
      });
    });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    _hero.getHeroes(widget.query).then((results) {
      setState(() {
        heroes = results;
      });
    });
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void filterSearchResults(String query) {}
  Future getImage(String image) async {
    if (image.isNotEmpty) {
      setState(() {
        heroImageFir = image;
        heroImageAvailable = true;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        setState(() {
          heroImage = response.file;
        });
      });
    } else {}
  }

  Future<bool> updateHeroDialog(
      BuildContext context, DocumentSnapshot existingHero) async {
    existingHero = existingHero;
    heroName = existingHero.data['heroName'];
    heroDescription = existingHero.data['heroDesc'];
    heroShortDescription = existingHero.data['heroShrtDesc'];
    print(existingHero.data);
    getImage(existingHero.data['heroImage']);
    retrieveLostData();
    documentID = existingHero.documentID;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            key: _scaffoldKey,
            title: Text(
              'Update a hero',
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
                            child: heroImageAvailable
                                ? (heroImage != null)
                                    ? Image.file(
                                        heroImage,
                                        fit: BoxFit.cover,
                                      )
                                    : FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/loading.gif',
                                        image: heroImageFir,
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
                          controller: TextEditingController()..text = heroName,
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
                          controller: TextEditingController()
                            ..text = heroShortDescription,
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
                          controller: TextEditingController()
                            ..text = heroDescription,
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
                      updateHero(context);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Update'))
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
      heroImage = tempImage;
      loading = false;
    });
  }

  Future updateHero(BuildContext context) async {
    SnackBar(
      content: Text('Your hero is updating.'),
      backgroundColor: Colors.green,
    );

    var downloadUrl;

    if (heroImage != null) {
      final StorageReference _storage = FirebaseStorage.instance
          .ref()
          .child('hero_pics/${this.documentID}_.jpg');

      StorageUploadTask _uploadTask = _storage.putFile(heroImage);

      StorageTaskSnapshot _taskSnapshot = await _uploadTask.onComplete;
      downloadUrl = await _taskSnapshot.ref.getDownloadURL();
      heroImage = downloadUrl;
    }

    Map<String, String> heroData = {
      'heroName': this.heroName,
      'heroDesc': this.heroDescription,
      'heroShrtDesc': this.heroShortDescription,
      'heroImage': downloadUrl
    };

    //await _hero.addHero(heroData);

    await _hero.updateHeroe(documentID, heroData);

    _onLoading();
    SnackBar(
      content: Text('Your hero updated successfully.'),
      backgroundColor: Colors.green,
    );

    Navigator.of(context).pop();
  }

  Future<void> _deleteAlert(String heroId, int index) async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Hero Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete?'),
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
                await _hero.deleteHeroById(heroId);
                Navigator.of(context).pop(true);
                _onLoading();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    if (heroes != null) {
      return Column(
        children: <Widget>[
          SearchField(),
          Expanded(
            child: SmartRefresher(
            enablePullUp: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.builder(
              itemCount: heroes.documents.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, i) {
                return Dismissible(
                  key: Key(i.toString()),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _deleteAlert(heroes.documents[i].documentID, i);
                    } else if (direction == DismissDirection.endToStart) {
                      updateHeroDialog(context, heroes.documents[i]);
                    }
                  },
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.green, Colors.greenAccent])),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                          width: 130.0,
                        ),
                        Text(
                          "Slide to Edit Hero",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0, width: 20.0),
                        Icon(
                          Icons.edit,
                        )
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.red, Colors.redAccent])),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                        ),
                        Text(
                          "Slide to Delete Hero",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0, width: 20.0),
                        Icon(
                          Icons.delete,
                        )
                      ],
                    ),
                  ),
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white70,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HeroDetailScreen(hero: heroes.documents[i]),
                          ),
                        );
                      },
                      leading: Column(
                        children: <Widget>[
                          Container(
                            width: 50.0,
                            height: 50.0,
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: heroes.documents[i].data['heroImage'] !=
                                      null
                                  ? FadeInImage.assetNetwork(
                                      image:
                                          heroes.documents[i].data['heroImage'],
                                      placeholder: 'assets/images/loading.gif',
                                      fit: BoxFit.fill)
                                  : Image.asset(
                                      'assets/images/hero.png',
                                      fit: BoxFit.cover,
                                    ),
                              elevation: 5,
                            ),
                          )
                        ],
                      ),
                      title: Text(
                        heroes.documents[i].data['heroName'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        heroes.documents[i].data['heroShrtDesc'],
                        style: TextStyle(color: Colors.black, fontSize: 12.0),
                      ),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  ),
                );
              },
            )),
      )]);
    } else {
      return Loading();
    }
  }
}
