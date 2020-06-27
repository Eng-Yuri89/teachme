import 'package:flutter/material.dart';
import 'package:teachme/models/notification.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/widgets/notification_card.dart';
import 'package:teachme/ui/widgets/screen_header.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ScreenHeader(title: 'Notifications'),
      SizedBox(height: screenAwareHeight(50, context)),
      // Body content
      Flexible(
        child: StreamBuilder<List<NotificationMessage>>(
            stream: Provider.of<DatabaseService>(context)
                .streamNotifications(Provider.of<User>(context).uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // Without notifications
                if (snapshot.data.length == 0) {
                  return Center(
                    child: Text('Notifications(0)'),
                  );
                }
                return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: screenAwareHeight(20, context),
                      );
                    },
                    itemBuilder: (context, index) {
                      return new Dismissible(
                          key: Key(snapshot.data[index].id),
                          onDismissed: (direction) {
                            Provider.of<DatabaseService>(context, listen: false)
                                .removeItem(
                                    'notifications', snapshot.data[index].id);
                            setState(() {
                              snapshot.data.removeAt(index);
                            });
                          },
                          background: Container(
                            alignment: Alignment(0.9, 0),
                            color: Color(0xffED3232),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          child: NotificationCard(
                              notification: snapshot.data[index]));
                    },
                    //separatorBuilder: (context, index) => SizedBox(height: 15.0),
                    itemCount: snapshot.data.length);
              }
            }),
      ),
    ]);
  }
}
