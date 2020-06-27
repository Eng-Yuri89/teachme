import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teachme/models/notification.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatelessWidget {
  final NotificationMessage notification;
  const NotificationCard({Key key, this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Converting the date from TimeStamp to Text and format
    final _date = Jiffy(
            DateTime.fromMillisecondsSinceEpoch(
                notification.dateTime.millisecondsSinceEpoch),
            "yyyy-MM-dd")
        .format("do MMM, yyyy");

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(30, context),
        //vertical: screenAwareHeight(20, context)
      ),
      child: InkWell(
        onTap: () async {
          //TODO change this call to the dabatase and call the manager for this action
          // Updating the status of the notification
          if (!notification.seen) {
            dynamic notificationUpdate = {
              "seen": true,
            };

            // Making an update to the Cloud Firestore
            await Provider.of<DatabaseService>(context, listen: false)
                .updateCollection(
                    'notifications', notificationUpdate, notification.id);
          }
        },
        child: new Container(
            height: screenAwareHeight(85, context),
            padding: EdgeInsets.symmetric(
                horizontal: screenAwareWidth(20, context),
                vertical: screenAwareHeight(10, context)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new Text(notification.title,
                        style: TextStyle(
                          color: Color(0xff060110),
                          fontSize: screenAwareWidth(15, context),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        )),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16),
                        SizedBox(
                          width: 4,
                        ),
                        new Text(_date,
                            style: TextStyle(
                              color: Color(0x7f060110),
                              fontSize: screenAwareWidth(9, context),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ))
                      ],
                    )
                  ],
                ),
                SizedBox(height: screenAwareHeight(10, context)),
                Row(
                  children: [
                    new Text(notification.message,
                        style: TextStyle(
                          color: Color(0xff060110),
                          fontSize: screenAwareWidth(13, context),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ))
                  ],
                )
              ],
            ),
            decoration: new BoxDecoration(
              color: notification.seen ? Color(0xfffbfbfd) : Color(0x267332ed),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFC4C4C4).withOpacity(0.3),
                    offset: Offset(0, 2),
                    blurRadius: 30,
                    spreadRadius: 0)
              ],
            )),
      ),
    );
  }
}
