import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

/// Profile screen
///
/// Returns the window with the personal
/// information of the user logged into the app.
class ProfileScreen extends StatelessWidget {
  static ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _userImage(context),
            _optionHeader("ACCOUNT", context),
            _option(title: "My Lessons", context: context),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(20, context)),
              child: Divider(color: _theme.backgroundColor.withOpacity(0.25)),
            ),
            _option(title: "My Teachers", context: context),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(20, context)),
              child: Divider(color: _theme.backgroundColor.withOpacity(0.25)),
            ),
            SizedBox(
              height: screenAwareHeight(30, context),
            ),
            _optionHeader("SETTINGS", context),
            _option(title: "Privacy Policy", context: context),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(20, context)),
              child: Divider(color: _theme.backgroundColor.withOpacity(0.25)),
            ),
            _option(title: "Terms of Use", context: context),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(20, context)),
              child: Divider(color: _theme.backgroundColor.withOpacity(0.25)),
            ),
            _option(title: "About", context: context),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(20, context)),
              child: Divider(color: _theme.backgroundColor.withOpacity(0.25)),
            ),
            SizedBox(
              height: screenAwareHeight(30, context),
            ),
            _option(title: "Log Out", context: context, hasTrailing: false),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(20, context)),
              child: Divider(color: _theme.backgroundColor.withOpacity(0.25)),
            ),
          ],
        ),
      ),
    );
  }

  ///Header creation
  Widget _userImage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(20, context),
        vertical: screenAwareHeight(30, context),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: screenAwareWidth(30, context),
            backgroundImage: AssetImage(
              "assets/profile/user_image.png",
            ),
          ),
          SizedBox(
            width: screenAwareWidth(19, context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Javier Cabrera",
                style: _theme.textTheme.subtitle2.copyWith(
                  color: _theme.backgroundColor,
                ),
              ),
              SizedBox(
                height: screenAwareHeight(10, context),
              ),
              Text(
                "Javiercabrera@gmail.com",
                style: _theme.textTheme.caption.copyWith(
                  color: _theme.backgroundColor,
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          Column(
            children: <Widget>[
              Image.asset(
                "assets/profile/edit_user.png",
                fit: BoxFit.fill,
                width: screenAwareWidth(16, context),
              ),
              SizedBox(
                height: screenAwareWidth(20, context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///Option header creation
  Widget _optionHeader(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
      child: Text(
        title,
        style: _theme.textTheme.subtitle1.copyWith(
          color: _theme.backgroundColor,
        ),
      ),
    );
  }

  ///Listtile creation
  Widget _option(
      {String title, BuildContext context, bool hasTrailing = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(5, context),
      ),
      child: ListTile(
        trailing: hasTrailing
            ? Icon(
                Icons.arrow_forward_ios,
                color: Color.fromRGBO(218, 218, 218, 1),
                size: screenAwareWidth(17, context),
              )
            : SizedBox(),
        title: Text(
          title,
          style: _theme.textTheme.subtitle2.copyWith(
            color: Color.fromRGBO(218, 218, 218, 1),
          ),
        ),
      ),
    );
  }
}
