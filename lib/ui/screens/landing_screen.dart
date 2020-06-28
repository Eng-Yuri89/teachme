import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachme/ui/screens/events/events_screen.dart';
import 'package:teachme/ui/screens/home/home_screen.dart';
import 'package:teachme/ui/screens/home/notification_screen.dart';
import 'package:teachme/ui/screens/home/profile_screen.dart';
import 'package:teachme/utils/size.dart';

/// Main landing screen.
class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // Variable to manage different screen
  // option for the bottom navigation bar
  int _currentIndex = 0;

  // List of different views
  // Transactions View
  // Balance View
  // Profile View
  List<Widget> _views;

  // Variable to indicate actual state
  bool active = true;

  // Position for the bottom bar option
  double optionPosition = 20;

  // List of positions for the options

  // Four items navigation bar
  List<double> positions = [0.05, 0.3, 0.55, 0.8];

  // Five items navigation bar
  //List<double> positions = [0.028, 0.2241, 0.4341, 0.6296, 0.8350];

  /// onIndexChanged
  ///
  /// Method to manage different
  /// views and refresh the actual
  /// index
  onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
      optionPosition = MediaQuery.of(context).size.width * positions[index];
    });
  }

  @override
  void initState() {
    super.initState();
    _views = [
      HomeScreen(),
      Container(
        color: Colors.white,
        child: Center(
          child: Text("Categories"),
        ),
      ),
      Container(
        color: Colors.white,
        child: Center(
          child: Text("Favorites"),
        ),
      ),
      ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _views[_currentIndex]),
      bottomNavigationBar: Container(
        height: screenAwareHeight(90, context),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 30,
                offset: Offset(0, -10)),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            BottomNavigationBar(
              selectedFontSize: screenAwareWidth(12, context),
              onTap: onIndexChanged,
              elevation: 3,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              items: <BottomNavigationBarItem>[
                // Home option.
                _option(
                  context,
                  "assets/landing/home.png",
                  "assets/landing/home_active.png",
                  "Home",
                  0,
                ),
                // Categories option.
                _option(
                  context,
                  "assets/landing/search.png",
                  "assets/landing/search_active.png",
                  "Categories",
                  1,
                ),
                // Favorite option.
                _option(
                  context,
                  "assets/landing/favorite.png",
                  "assets/landing/favorite_active.png",
                  "Favorites",
                  2,
                ),
                // Profile option.
                _option(
                  context,
                  "assets/landing/profile.png",
                  "assets/landing/profile_active.png",
                  "Profile",
                  3,
                ),
              ],
            ),

            // Diferent positions for every bottom bar
            // option
            // home> 25
            // balance > 125
            // transactions > 230
            // profile > 335
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOutSine,
              top: 0,
              //left: optionPosition,
              left: optionPosition,
              child: Container(
                width: screenAwareWidth(55, context),
                height: screenAwareHeight(3, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the bottom navitagion bar option.
  BottomNavigationBarItem _option(BuildContext context, String image,
      String imageActive, String title, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        margin: EdgeInsets.only(bottom: screenAwareHeight(5, context)),
        child: Image.asset(
          image,
          fit: BoxFit.fill,
          width: screenAwareWidth(20, context),
        ),
      ),
      activeIcon: Container(
        margin: EdgeInsets.only(bottom: screenAwareHeight(5, context)),
        child: Image.asset(
          imageActive,
          fit: BoxFit.fill,
          width: screenAwareWidth(23, context),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _currentIndex == index
              ? Theme.of(context).backgroundColor
              : Theme.of(context).backgroundColor.withOpacity(0.5),
          fontSize: screenAwareWidth(12, context),
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
