import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_heroes/screens/auth/login.dart';
import 'package:our_heroes/utilities/styles.dart';

class OnboardingScreen extends StatefulWidget {
  
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];

    for(int i = 0; i < _numPages; i++){
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return list;
  }

  Widget _indicator(bool isActive){

    return AnimatedContainer(duration: Duration(microseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    height: 8.0,
    width: isActive ? 24.0 : 16.0,
    decoration: BoxDecoration(
      color: isActive ? Colors.white : Color(0xFF9E9E9E),
      borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF7986CB),
                Color(0xFF3F51B5),
                Color(0xFF283593),
                Color(0xFF1A237E),
              ]
            )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () => print("Skip"),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0
                      )
                    ),
                  ),
                  
                ),
                Container(
                    height: 501.0,
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage('assets/images/onboarding0.png'),
                                  height: 250.0,
                                  width: 300.0,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                'Our heroes...',
                                style: kTitleStyle,
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Sri Lankan super heroes',
                                style: kSubtitleStyle,
                              ),
                              
                            ],
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage('assets/images/onboarding3.png'),
                                  height: 250.0,
                                  width: 300.0,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                'Sacrifice themselves...',
                                style: kTitleStyle,
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'to protect our country',
                                style: kSubtitleStyle,
                              ),
                              
                            ],
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage('assets/images/onboarding2.png'),
                                  height: 250.0,
                                  width: 300.0,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                'This is our chance...',
                                style: kTitleStyle,
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'to show them a small gratitude',
                                style: kSubtitleStyle,
                              ),
                              
                            ],
                          )
                        )
                        
                      ],
                    ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                 ? Expanded(
                   child: Align(
                     alignment: FractionalOffset.bottomRight,
                     child: FlatButton(
                       onPressed: () {
                         _pageController.nextPage(duration: Duration(microseconds: 500), curve: Curves.ease);
                       },
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         mainAxisSize: MainAxisSize.min,
                         children: <Widget>[
                           Text(
                             'Next',
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 18.0
                              ),
                           ),
                           SizedBox(width: 10.0),
                           Icon(
                             Icons.arrow_forward,
                             color: Colors.white,
                             size: 23.0,
                            )
                         ],
                        ),
                      ),
                   )
                  )
                  : Text('')
              ],
            ),
          )
          
        )
      ),
      bottomSheet: _currentPage == _numPages - 1
        ? Container(
          height: 100.0,
          width: double.infinity,
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Color(0xFF3F51B5),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  ),

                )
              )
            )
            
          )
        )
        : Text(''),
    );
  }
}
