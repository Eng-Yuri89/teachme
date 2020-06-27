import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teachme/models/mail.dart';
import 'package:teachme/models/office.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/screens/mail/mail_detail_screen.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

/// Mail card widget.
class MailCard extends StatelessWidget {
  // Mail.
  final Mail mail;

  MailCard({@required this.mail});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            width: screenAwareWidth(250, context),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 1,
                child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // Mail header.
                          _mailHeader(context, mail),
                          SizedBox(height: screenAwareHeight(20, context)),
                          // Mail description.
                          _mailDescription(context, mail),
                          SizedBox(height: screenAwareHeight(15, context)),
                          // Mail adds and status.
                          _mailStatus(context, mail)
                        ])))),
        onTap: () {
          navigateTo(context, MailDetailScreen(mail: mail));
        });
  }

  /// Return the mail header.
  Widget _mailHeader(BuildContext context, Mail mail) {
    final _date = Jiffy(
            DateTime.fromMillisecondsSinceEpoch(
                mail.dateTime.millisecondsSinceEpoch),
            "yyyy-MM-dd")
        .format("do MMM, yyyy");

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Mail office.
        FutureBuilder<Office>(
            future:
                Provider.of<DatabaseService>(context).getMyOffice(mail.office),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return AutoSizeText(snapshot.data.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xff060110),
                      fontSize: screenAwareWidth(14, context),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal));
            }),
        // Date mail information.
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Calendar icon.
              SvgPicture.asset(
                "assets/calendar.svg",
                fit: BoxFit.fill,
                width: screenAwareWidth(10, context),
              ),
              SizedBox(width: screenAwareWidth(3.3, context)),
              // Date text.
              Text(
                _date,
                style: TextStyle(
                  color: Color(0xb2000000),
                  fontSize: screenAwareWidth(8, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  /// Return the mail description.
  Widget _mailDescription(BuildContext context, Mail mail) {
    return Container(
      width: double.infinity,
      child: Text(
        mail.description,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Color(0xff060110),
          fontSize: screenAwareWidth(12, context),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }

  /// Returns the attachment counter and mail status.
  Widget _mailStatus(BuildContext context, Mail mail) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // Images count.
        _mailImagesCount(mail, context),
        SizedBox(width: screenAwareWidth(5, context)),
        // Mail status.
        _mailStatusIndicator(context, mail),
      ],
    );
  }

  /// Returns the mail images count.
  Widget _mailImagesCount(Mail mail, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Images info.
        Row(
          children: <Widget>[
            // Image icon.
            SvgPicture.asset(
              "assets/calendar.svg",
              fit: BoxFit.fill,
              width: screenAwareWidth(10, context),
            ),
            SizedBox(width: screenAwareWidth(5, context)),
            // Images text.
            Text("Images",
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(8, context),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal))
          ],
        ),
        SizedBox(height: screenAwareHeight(8, context)),
        // Image count.
        Text(
          getNumberOfImagesOfTheMail(mail).toString(),
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: screenAwareWidth(10, context),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        )
      ],
    );
  }

  /// Returns the mail status indicator.
  Widget _mailStatusIndicator(BuildContext context, Mail mail) {
    // Status indicator color.
    Color _backgoundColor;
    // Font color.
    Color _fontColor;

    if (mail.status.toUpperCase() == "UNRESOLVED") {
      _backgoundColor = Theme.of(context).primaryColor;
      _fontColor = Color(0xfffefefe);
    } else {
      _backgoundColor = Color.fromRGBO(209, 229, 83, 1);
      _fontColor = Color(0xff060110);
    }

    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Mail status info.
          Row(
            children: <Widget>[
              // Send icon.
              SvgPicture.asset(
                "assets/send.svg",
                fit: BoxFit.fill,
                width: screenAwareWidth(10, context),
              ),
              SizedBox(width: screenAwareWidth(5, context)),
              // Mail status text.
              Text("Status",
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: screenAwareWidth(8, context),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal))
            ],
          ),
          SizedBox(height: screenAwareHeight(8, context)),
          // Mail status.
          Container(
              width: screenAwareWidth(65, context),
              height: screenAwareHeight(14, context),
              decoration: BoxDecoration(
                  color: _backgoundColor,
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Text(mail.status.toUpperCase(),
                    style: TextStyle(
                        color: _fontColor,
                        fontSize: screenAwareWidth(7, context),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal)),
              ))
        ]);
  }
}
