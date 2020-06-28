import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

class AboutScreen extends StatelessWidget {
  static ThemeData _theme;
  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _pageHeader(context),
            SizedBox(
              height: screenAwareHeight(10, context),
            ),
            _flagImage(context),
            SizedBox(
              height: screenAwareHeight(10, context),
            ),
            _subtitle("2020", context),
          ],
        ),
      ),
    );
  }

  /// Returns the page header
  Widget _pageHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenAwareHeight(320, context)),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "teach",
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
      alignment: Alignment.center,
    );
  }

  ///Return the text with the flag
  Widget _flagImage(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "was made in",
              style: _theme.textTheme.headline6.copyWith(
                color: _theme.backgroundColor,
              ),
            ),
          ],
        ),
        SizedBox(
          width: screenAwareHeight(8, context),
        ),
        Image.asset(
          "assets/about/flag.png",
          fit: BoxFit.fill,
          width: screenAwareWidth(15, context),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  ///subtitle creation
  Widget _subtitle(String title, BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: _theme.textTheme.subtitle2.copyWith(
            color: _theme.backgroundColor,
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
