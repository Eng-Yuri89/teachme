import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachme/models/mail.dart';
import 'package:teachme/models/office.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/widgets/circle_button.dart';
import 'package:teachme/ui/widgets/mail_package_card.dart';
import 'package:teachme/ui/widgets/page_header.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

/// Mail detail screen
///
/// Returns detail of the selected mail.
class MailDetailScreen extends StatefulWidget {
  // Mail selected.
  final Mail mail;

  MailDetailScreen({@required this.mail});

  @override
  _MailDetailScreenState createState() => _MailDetailScreenState();
}

class _MailDetailScreenState extends State<MailDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Page header.
            _pageHeader(context),
            // Mail header.
            _mailHeader(context),
            SizedBox(height: screenAwareHeight(20, context)),
            // Mail description.
            _mailDescription(context),
            SizedBox(height: screenAwareHeight(30, context)),
            // Packages header.
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(30, context)),
              child: Text(
                "Packages",
                style: TextStyle(
                  color: Theme.of(context).buttonColor,
                  fontSize: screenAwareWidth(14, context),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            // Packages mail.
            _mailPackages(context)
          ],
        ),
      ),
    );
  }

  /// Returns the page header.
  Widget _pageHeader(context) {
    return Container(
      margin: EdgeInsets.only(
          top: screenAwareHeight(25, context),
          bottom: screenAwareHeight(30, context)),
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Arrow to go back and title.
          PageHeader(
            color: Theme.of(context).buttonColor,
            fontWeight: FontWeight.bold,
            arrowSize: screenAwareWidth(25, context),
            fontSize: screenAwareWidth(18, context),
            title: "Mail Detail",
          ),
          //_mailActions(context)
        ],
      ),
    );
  }

  /// Returns the actions of the mail.
  Widget _mailActions(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      // Edit mail action button.
      CircleButton(
          radius: screenAwareWidth(30, context),
          backgroundColor: Color(0xffed8332),
          child:
              SvgPicture.asset("assets/edit_mail.svg", fit: BoxFit.scaleDown),
          onTap: () {
            print("Edit mail button pressed");
          }),
      SizedBox(width: screenAwareWidth(6, context)),
      // Delete mail action button.
      CircleButton(
          radius: screenAwareWidth(30, context),
          backgroundColor: Color(0xffed8332),
          child:
              SvgPicture.asset("assets/delete_mail.svg", fit: BoxFit.scaleDown),
          onTap: () {
            print("Delete mail button pressed");
          })
    ]);
  }

  /// Returns the mail header information.
  Widget _mailHeader(BuildContext context) {
    // Status indicator color.
    Color _backgoundColor;
    // Font color.
    Color _fontColor;

    if (widget.mail.status == "UNRESOLVED") {
      _backgoundColor = Theme.of(context).primaryColor;
      _fontColor = Color(0xfffefefe);
    } else {
      _backgoundColor = Color.fromRGBO(209, 229, 83, 1);
      _fontColor = Color(0xff060110);
    }

    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Mail office.
              Flexible(
                  child: FutureBuilder<Office>(
                      future: Provider.of<DatabaseService>(context)
                          .getMyOffice(widget.mail.office),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return AutoSizeText(snapshot.data.name,
                            maxLines: 1,
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: screenAwareWidth(14, context),
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal));
                      })),
              // Mail status indicator.
              Flexible(
                  child: FittedBox(
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenAwareWidth(8, context),
                        vertical: screenAwareHeight(5, context)),
                    decoration: BoxDecoration(
                        color: _backgoundColor,
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: Text(widget.mail.status.toUpperCase(),
                          style: TextStyle(
                              color: _fontColor,
                              fontSize: screenAwareWidth(9, context),
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal)),
                    )),
              ))
            ]));
  }

  /// Returns the mail description.
  Widget _mailDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RichText(
              textAlign: TextAlign.justify,
              text: new TextSpan(children: [
                new TextSpan(
                    text: "Description",
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: screenAwareWidth(12, context),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal)),
                new TextSpan(
                    text: ": ${widget.mail.description}",
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: screenAwareWidth(12, context),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal))
              ])),
        ],
      ),
    );
  }

  /// Returns the packages of the mail.
  Widget _mailPackages(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: Provider.of<DatabaseService>(context)
            .getPackagesMailStream(widget.mail.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final _list = snapshot.data;

            return _list.length > 0
                ? ListView.separated(
                    padding: EdgeInsets.only(
                      left: screenAwareWidth(30, context),
                      right: screenAwareWidth(30, context),
                      bottom: screenAwareWidth(30, context),
                      top: screenAwareWidth(15, context),
                    ),
                    itemCount: _list.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: screenAwareHeight(15, context),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return MailPackageCard(package: _list[index]);
                    },
                  )
                : Center(
                    child: Text(
                      "Packages (0)",
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: screenAwareWidth(12, context),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.4),
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            );
          }
        },
      ),
    );
  }
}
