import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  const ScreenHeader({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenAwareHeight(50, context)),
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Row(
        children: [
          new Text(title,
              style: TextStyle(
                color: Color(0xff060110),
                fontSize: screenAwareWidth(30, context),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ))
        ],
      ),
    );
  }
}
