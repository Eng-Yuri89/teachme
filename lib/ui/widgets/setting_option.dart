import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachme/utils/size.dart';

class SettingOption extends StatelessWidget {
  final String optionName;
  final String imageIcon;
  final Function onGo;
  const SettingOption({Key key, this.optionName, this.imageIcon, this.onGo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(30, context),
          vertical: screenAwareHeight(5, context)),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                SvgPicture.asset(imageIcon,
                    fit: BoxFit.fill,
                    height: screenAwareWidth(18, context),
                    width: screenAwareWidth(18, context)),
                SizedBox(
                  width: screenAwareWidth(10, context),
                ),
                new Text(optionName,
                    style: TextStyle(
                      color: Color(0xff060110),
                      fontSize: screenAwareWidth(14, context),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    )),
              ],
            ),
            IconButton(
                onPressed: onGo,
                icon: Icon(
                  Icons.arrow_right,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ))
          ],
        ),
      ),
    );
  }
}
