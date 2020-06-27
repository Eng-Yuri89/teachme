import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

/// Header of the application pages.
class PageHeader extends StatelessWidget {
  // Page header color.
  final Color color;
  // Arrow size.
  final double arrowSize;
  // Font size.
  final double fontSize;
  // Title page.
  final String title;
  // Font wight.
  final FontWeight fontWeight;

  PageHeader(
      {this.color,
      @required this.arrowSize,
      @required this.fontSize,
      this.title,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Arrow to go back.
          InkWell(
              child: Icon(Icons.arrow_back,
                  color: color == null ? Color(0xff000000) : color,
                  size: arrowSize),
              onTap: () {
                Navigator.pop(context);
              }),
          SizedBox(width: screenAwareWidth(15, context)),
          // Title page.
          Text(title,
              style: TextStyle(
                  color: color == null ? Color(0xff000000) : color,
                  fontSize: fontSize,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  fontStyle: FontStyle.normal))
        ]);
  }
}
