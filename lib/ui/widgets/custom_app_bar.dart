import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(25, context),
          vertical: screenAwareHeight(20, context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: ImageIcon(
              AssetImage('assets/icons/back.png'),
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
          SizedBox(
            width: screenAwareWidth(20, context),
          ),
          ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: screenAwareWidth(250, context)),
            child: new Text(title,
                style: TextStyle(
                  color: Color(0xff395378),
                  fontSize: screenAwareWidth(25, context),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1.25,
                )),
          ),
        ],
      ),
    );
  }
}
