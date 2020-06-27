import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

class StadisticsProfileCard extends StatelessWidget {
  const StadisticsProfileCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(30, context),
          vertical: screenAwareHeight(20, context)),
      child: new Container(
          height: screenAwareHeight(85, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Notifications
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text("Notifications",
                      style: TextStyle(
                        color: Color(0xff060110),
                        fontSize: screenAwareWidth(12, context),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                  SizedBox(height: screenAwareHeight(5, context)),
                  new Text("2",
                      style: TextStyle(
                        color: Color(0xff060110),
                        fontSize: screenAwareWidth(16, context),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              ),
              // Separator
              Container(
                width: 1,
                height: screenAwareHeight(38, context),
                color: Color(0xff060110),
              ),
              // Notifications
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text("Unresolved Mail",
                      style: TextStyle(
                        color: Color(0xff060110),
                        fontSize: screenAwareWidth(12, context),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                  SizedBox(height: screenAwareHeight(5, context)),
                  new Text("26",
                      style: TextStyle(
                        color: Color(0xff060110),
                        fontSize: screenAwareWidth(16, context),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              ),
              // Separator
              Container(
                width: 1,
                height: screenAwareHeight(38, context),
                color: Color(0xff060110),
              ),
              // Notifications
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text("Offices",
                      style: TextStyle(
                        color: Color(0xff060110),
                        fontSize: screenAwareWidth(12, context),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                  SizedBox(height: screenAwareHeight(5, context)),
                  new Text("2",
                      style: TextStyle(
                        color: Color(0xff060110),
                        fontSize: screenAwareWidth(16, context),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              ),
            ],
          ),
          decoration: new BoxDecoration(
            color: Color(0xfffbfbfd),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFFC4C4C4).withOpacity(0.3),
                  offset: Offset(0, 2),
                  blurRadius: 30,
                  spreadRadius: 0)
            ],
          )),
    );
  }
}
