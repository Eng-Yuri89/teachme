import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

/// Home screen
///
/// Main page showing the recommended
/// and best ranked courses.
class HomeScreen extends StatelessWidget {
  //Global theme.
  ThemeData _theme;
  // Recommended list.
  List<Map<String, dynamic>> _recommendedList = List<Map<String, dynamic>>();

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //Page header.
            _pageHeader(context)
          ],
        ),
      ),
    );
  }

  ///Returns the title of the page.
  Widget _pageHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        screenAwareWidth(20, context),
      ),
      child: Text(
        "Recommended",
        style:
            _theme.textTheme.headline6.copyWith(color: _theme.backgroundColor),
      ),
    );
  }
}
