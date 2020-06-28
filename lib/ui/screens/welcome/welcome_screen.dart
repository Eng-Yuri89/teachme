import 'package:flutter/material.dart';
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
            children: <Widget>[
              _pageHeader(context),
            ],
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
          "assets/login_icon.png",
          fit: BoxFit.fill,
          width: screenAwareWidth(44, context),
        ),
        SizedBox(
          height: screenAwareHeight(40, context),
        ),
        Text(
          "Create an Account to start learning",
          style: _theme.textTheme.subtitle2
              .copyWith(color: _theme.backgroundColor),
        ),
        SizedBox(
          height: screenAwareHeight(30, context),
        ),
        Text(
          "When you create a new account you accept the Terms of Use of TeachMe",
          style: _theme.textTheme.subtitle2
              .copyWith(color: _theme.backgroundColor),
        ),
      ],
    );
  }
}
