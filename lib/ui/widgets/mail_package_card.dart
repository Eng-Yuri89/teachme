import 'package:flutter/material.dart';
import 'package:teachme/models/mail.dart';
import 'package:teachme/ui/screens/mail/package_detail_screen.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';
import 'package:uuid/uuid.dart';

/// Mail package card.
class MailPackageCard extends StatelessWidget {
  // Package.
  final Package package;
  // Hero animation uniqueid.
  final _uniqueId = "PackageImage-${new Uuid().v4()}";

  MailPackageCard({@required this.package});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            width: screenAwareWidth(248.3, context),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Image url.
                      _packageImage(context),
                      SizedBox(height: screenAwareHeight(10, context)),
                      // Package information.
                      _packageInformation(context),
                      SizedBox(height: screenAwareHeight(3, context)),
                      _packageAction(context)
                    ]))),
        onTap: () {
          navigateTo(context,
              PackageDetailScreen(package: package, uniqueId: _uniqueId));
        });
  }

  /// Package image
  Widget _packageImage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(screenAwareWidth(10, context)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Hero(
            tag: _uniqueId,
            child: FadeInImage(
                width: double.infinity,
                height: screenAwareHeight(174.4, context),
                fit: BoxFit.fitWidth,
                placeholder: AssetImage("assets/load.gif"),
                image: NetworkImage(package.imageUrl ??
                    "https://media.graytvinc.com/images/690*388/Holiday+shipping+12+12.JPG")),
          )),
    );
  }

  /// Returns the package information.
  Widget _packageInformation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(8, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Package type text.
          Text(package.type.toUpperCase(),
              style: TextStyle(
                color: Color(0xff000000),
                fontSize: screenAwareWidth(12, context),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              )),
          SizedBox(height: screenAwareHeight(7, context)),
          // Package condition.
          RichText(
              text: new TextSpan(children: [
            new TextSpan(
                text:
                    "This package will not be in your mail slot or you may be required to sign for it: ",
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal)),
            new TextSpan(
                text: package.storagecost ? "SI" : "NO",
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal))
          ]))
        ],
      ),
    );
  }

  /// Shows the action that have
  /// been taken with the package.
  Widget _packageAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenAwareWidth(8, context),
              vertical: screenAwareHeight(5, context),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              package.action.toUpperCase(),
              maxLines: 1,
              style: TextStyle(
                color: Color(0xfffefefe),
                fontSize: screenAwareWidth(9, context),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
            ),
          )
        ],
      ),
    );
  }
}
