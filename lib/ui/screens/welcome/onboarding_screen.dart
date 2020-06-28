import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:teachme/ui/screens/welcome/welcome_screen.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// OnBoarding screen.
///
/// Page with the PageView of the modules offered by the application.
class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // Current page indicator.
  ValueNotifier<int> _page = new ValueNotifier<int>(0);
  // PageView controller.
  PageController _pageController =
      new PageController(initialPage: 0, viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    //Theme data information
    ThemeData _theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Page header
            _pageHeader(context, _theme)
            /* PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                //Mails page.
                _mailsPage(context),
                //Fast and secure page.
                _securePage(context),
                //Events free page.
                _eventsPage(context)
              ],
              onPageChanged: (index) {
                _page.value = index;

                setState(() {});
              },
            ), */
          ],
        ),
      ),
      bottomNavigationBar: _pageIndicator(context),
    );
  }

  /// Returns the page header
  Widget _pageHeader(BuildContext context, ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(top: screenAwareHeight(50, context)),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "Teach",
                style: theme.textTheme.headline4.copyWith(
                  color: theme.backgroundColor,
                ),
              ),
              TextSpan(
                text: "ME",
                style: theme.textTheme.headline4.copyWith(
                  color: theme.primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the page indicating that
  ///  emails can be managed.
  Widget _mailsPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Mails manage image.
        Center(
          child: SvgPicture.asset(
            "assets/onboarding_mails.svg",
            fit: BoxFit.fill,
            width: screenAwareWidth(285, context),
          ),
        ),
        SizedBox(height: screenAwareHeight(65.8, context)),
        //Page text.
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: Text(
            "Manage your mails",
            style: TextStyle(
              color: Theme.of(context).buttonColor,
              fontSize: screenAwareWidth(24, context),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        SizedBox(height: screenAwareHeight(16, context)),
        //Description page.
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: Text(
            "Accept, take fast actions, send information about you want to manager your packages.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the page indicates speed and security in the application.
  Widget _securePage(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Mails manage image.
          Center(
              child: SvgPicture.asset("assets/onboarding_secure.svg",
                  fit: BoxFit.fill, width: screenAwareWidth(285, context))),
          SizedBox(height: screenAwareHeight(65.8, context)),
          //Page text.
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
            child: Text("Fast and secure",
                style: TextStyle(
                    color: Theme.of(context).buttonColor,
                    fontSize: screenAwareWidth(24, context),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal)),
          ),
          SizedBox(height: screenAwareHeight(16, context)),
          //Description page.
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
            child: Text(
                "Take control of all your packages in real time, receive push notifications and news about events and coworking.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(14, context),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal)),
          )
        ]);
  }

  /// Returns the page indicates that free events can be created.
  Widget _eventsPage(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Mails manage image.
          Center(
              child: SvgPicture.asset("assets/onboarding_events.svg",
                  fit: BoxFit.fill, width: screenAwareWidth(285, context))),
          SizedBox(height: screenAwareHeight(65.8, context)),
          //Page text.
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
            child: Text("Events for free",
                style: TextStyle(
                    color: Theme.of(context).buttonColor,
                    fontSize: screenAwareWidth(24, context),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal)),
          ),
          SizedBox(height: screenAwareHeight(16, context)),
          //Description page.
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
            child: Text(
                "Accept, take fast actions, send information about you want to manager your packages.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(14, context),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal)),
          )
        ]);
  }

  /// Create the page indicator and button to jump to the next page.
  Widget _pageIndicator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(screenAwareWidth(30, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Page indicator.
          CirclePageIndicator(
            itemCount: 3,
            currentPageNotifier: _page,
            dotColor: Color(0xff8a959a),
            selectedDotColor: Theme.of(context).primaryColor,
            size: screenAwareWidth(10, context),
            selectedSize: screenAwareWidth(10, context),
            onPageSelected: (index) {
              _page.value = index;

              _pageController.jumpToPage(index);

              setState(() {});
            },
          ),
          GestureDetector(
            child: AnimatedCrossFade(
              crossFadeState: _page.value < 2
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstCurve: Curves.slowMiddle,
              secondCurve: Curves.slowMiddle,
              firstChild: Text(
                "Skip",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: screenAwareWidth(16, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              secondChild: Text(
                "Get Started",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: screenAwareWidth(16, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              duration: Duration(milliseconds: 350),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool("first-run", true);

              navigateToPushReplace(context, WelcomeScreen());
            },
          ),
        ],
      ),
    );
  }
}
