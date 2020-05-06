import 'package:flutter/material.dart';
import 'package:our_heroes/pages/my_heros_page.dart';
import 'package:our_heroes/pages/user_profile.dart';
import '../../pages/home_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentTabIndex = 0;
  List<Widget> pages;
  Widget currentPage;

  HomePage homePage;
  MyHerosPage myHerosPage;
  UserProfilePage userProfilePage;

  @override
  void initState() {
    super.initState();
    
    homePage = HomePage();
    myHerosPage = MyHerosPage();
    userProfilePage = UserProfilePage();

    pages = [homePage, myHerosPage, userProfilePage];

    currentPage = homePage;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index){
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        elevation: 0.0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("My Heros")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile")
          ),
        ]
      ),
      body: currentPage,
    );
  }
}