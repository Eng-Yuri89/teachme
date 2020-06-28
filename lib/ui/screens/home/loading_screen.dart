import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

class LoadingScreen extends StatelessWidget {
  static ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[_pageHeader(context)],
      )),
    );
  }

  /// Returns the page header
  Widget _pageHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenAwareHeight(330, context)),
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
}
