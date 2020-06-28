import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:teachme/utils/size.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/utils/size.dart';
import 'package:teachme/ui/screens/welcome/welcome_screen.dart';
import 'package:teachme/utils/helper_functions.dart';

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
  // Declaration of the topic defined
  // in the global configuration
  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    //Theme data information
    _theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Page header
            _pageHeader(context),
            //Pages of information
            _pages(context),
            //Pages indicator.
            _pageIndicator(context),
            SizedBox(
              height: screenAwareHeight(40, context),
            )
          ],
        ),
      ),
      bottomNavigationBar: _startButton(context),
    );
  }

  /// Returns the page header
  Widget _pageHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenAwareHeight(40, context)),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "Teach",
                style: _theme.textTheme.headline4.copyWith(
                  color: _theme.backgroundColor,
                ),
              ),
              TextSpan(
                text: "ME",
                style: _theme.textTheme.headline4.copyWith(
                  color: _theme.primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the pages of information
  /// to the application
  Widget _pages(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          //Learning page.
          _learningPage(context),
          //People page.
          _peoplePage(context),
          //Class page.
          _classPage(context)
        ],
        onPageChanged: (index) {
          _page.value = index;

          setState(() {});
        },
      ),
    );
  }

  /// Returns the page indicating that
  /// it is learned in the application.
  Widget _learningPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Mails manage image.
        Center(
          child: Image.asset(
            "assets/onboarding/learning_page.png",
            fit: BoxFit.fill,
            width: screenAwareWidth(250, context),
          ),
        ),
        SizedBox(height: screenAwareHeight(65.8, context)),
        //Description page.
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: Text(
            "Learn music, math, physic training, from your home.",
            textAlign: TextAlign.center,
            style: _theme.textTheme.subtitle1.copyWith(
              color: _theme.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns the page that indicates
  /// that the app is used worldwide.
  Widget _peoplePage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Mails manage image.
        Center(
          child: Image.asset(
            "assets/onboarding/people_page.png",
            fit: BoxFit.fill,
            width: screenAwareWidth(250, context),
          ),
        ),
        SizedBox(height: screenAwareHeight(65.8, context)),
        //Description page.
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: Text(
            "People from everywhere  around world at any time.",
            textAlign: TextAlign.center,
            style: _theme.textTheme.subtitle1.copyWith(
              color: _theme.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _classPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Mails manage image.
        Center(
          child: Image.asset(
            "assets/onboarding/class_page.png",
            fit: BoxFit.fill,
            width: screenAwareWidth(250, context),
          ),
        ),
        SizedBox(height: screenAwareHeight(65.8, context)),
        //Description page.
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: Text(
            "Never lose a test again, be the best in you class.",
            textAlign: TextAlign.center,
            style: _theme.textTheme.subtitle1.copyWith(
              color: _theme.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }

  /// Create the page indicator and button to jump to the next page.
  Widget _pageIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Page indicator.
        CirclePageIndicator(
          itemCount: 3,
          currentPageNotifier: _page,
          dotColor: const Color.fromRGBO(133, 133, 139, 1),
          selectedDotColor: Theme.of(context).backgroundColor,
          size: screenAwareWidth(10, context),
          selectedSize: screenAwareWidth(10, context),
          onPageSelected: (index) {
            _page.value = index;

            _pageController.jumpToPage(index);

            setState(() {});
          },
        )
      ],
    );
  }

  ///Returns the button that takes
  ///us to the page to log in.
  Widget _startButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
        child: MainButton(
          enabledColor: _theme.primaryColor,
          isLoading: false,
          borderRadius: 5,
          height: screenAwareHeight(50, context),
          enabled: true,
          child: Text(
            "Start Learning",
            style: _theme.textTheme.button.copyWith(
              color: _theme.backgroundColor,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
