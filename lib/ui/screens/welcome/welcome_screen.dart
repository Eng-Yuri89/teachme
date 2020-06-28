import 'package:flutter/material.dart';
import 'package:teachme/ui/screens/landing_screen.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/utils/size.dart';

/// Welcome screen.
///
/// Welcome page where you select whether
/// you want to log in or register.
class WelcomeScreen extends StatelessWidget {
  //Application theme
  static ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[_pageHeader(context), _buttons(context)],
          ),
        ),
      ),
    );
  }

  ///Returns the icon with the login information
  Widget _pageHeader(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: screenAwareHeight(60, context),
        ),
        Image.asset(
          "assets/welcome/login_icon.png",
          fit: BoxFit.fill,
          width: screenAwareWidth(44, context),
        ),
        SizedBox(
          height: screenAwareHeight(40, context),
        ),
        Text(
          "Create an Account to start learning",
          style: _theme.textTheme.subtitle2.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
        SizedBox(
          height: screenAwareHeight(30, context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenAwareWidth(20, context),
          ),
          child: Text(
            "When you create a new account you accept\n the Terms of Use of TeachMe",
            style: _theme.textTheme.subtitle2.copyWith(
              color: const Color.fromRGBO(249, 249, 255, 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: screenAwareHeight(60, context),
        ),
      ],
    );
  }

  ///Login buttons are created
  Widget _buttons(BuildContext context) {
    return Column(
      children: <Widget>[
        _facebookButton(context),
        SizedBox(
          height: screenAwareHeight(20, context),
        ),
        Text(
          "or",
          style: _theme.textTheme.subtitle1.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
        SizedBox(
          height: screenAwareHeight(20, context),
        ),
        _googleButton(context),
      ],
    );
  }

  ///Returns the button to log in with Facebook
  Widget _facebookButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
      child: MainButton(
        enabledColor: const Color.fromRGBO(90, 126, 255, 1),
        isLoading: false,
        borderRadius: 5,
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LandingScreen()));
        },
        height: screenAwareHeight(50, context),
        enabled: true,
        child: Text(
          "Continue with Facebook",
          style: _theme.textTheme.button.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
      ),
    );
  }

  ///Returns the button to log in with Google
  Widget _googleButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
      child: MainButton(
        enabledColor: const Color.fromRGBO(255, 90, 90, 1),
        isLoading: false,
        borderRadius: 5,
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LandingScreen()));
        },
        height: screenAwareHeight(50, context),
        enabled: true,
        child: Text(
          "Continue with Google",
          style: _theme.textTheme.button.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
      ),
    );
  }
}
