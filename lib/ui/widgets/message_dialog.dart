import 'package:flutter/material.dart';
import 'package:teachme/ui/screens/landing_screen.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({Key key, this.title, this.body, this.onTap})
      : super(key: key);

  /// Message title
  final String title;

  /// Message body
  final String body;

  /// handler method
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1A1B1D),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        width: 327.0,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Title
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Theme.of(context).backgroundColor)),
            SizedBox(
              height: 16,
            ),
            // Body Alert Dialog
            Center(
              child: Text(body,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Theme.of(context).backgroundColor)),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Image.asset(
                'assets/teacher/check-circle.png',
                width: screenAwareWidth(50, context),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            MainButton(
              enabledColor: Theme.of(context).primaryColor,
              disableColor: Color.fromRGBO(116, 115, 131, 1),
              child: Text(
                'OKAY',
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Theme.of(context).accentColor,
                    ),
              ),
              enabled: true,
              height: screenAwareHeight(50, context),
              isLoading: false,
              borderRadius: screenAwareWidth(5, context),
              onTap: () {
                int pagesBack = 0;
                Navigator.of(context).popUntil((route) => pagesBack++ == 3);
              },
            )
          ],
        ),
      ),
    );
  }
}
