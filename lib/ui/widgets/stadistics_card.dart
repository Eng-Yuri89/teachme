import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

/// Stadistics card.
class StadisticsCard extends StatelessWidget {
  // Card title.
  final String title;
  // Count stadistic.
  final int count;

  StadisticsCard({@required this.title, @required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenAwareHeight(85, context),
      decoration: new BoxDecoration(
          color: Color(0xfffbfbfd),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0x4cc4c4c4),
              offset: Offset(0, 15),
              blurRadius: 30,
              spreadRadius: 5,
            )
          ]),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    color: Color(0xff060110),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal)),
            SizedBox(height: screenAwareHeight(5, context)),
            Text(
              count.toString(),
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontSize: screenAwareHeight(16, context),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
