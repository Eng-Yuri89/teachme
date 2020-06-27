import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teachme/models/event.dart';
import 'package:teachme/ui/screens/events/event_detail_screen.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';
import 'package:uuid/uuid.dart';
import 'package:share/share.dart';
import 'package:teachme/models/user.dart';

/// Event card.
class EventCard extends StatelessWidget {
  // Event
  final Event event;
  // Hero animation uniqueid.
  final _uniqueId = "PackageImage-${new Uuid().v4()}";
  // User conected.
  final User user;

  EventCard({this.event, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenAwareWidth(250, context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Stack(children: <Widget>[
                // Event information.
                InkWell(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: _eventInformation(context)),
                    onTap: () {
                      navigateTo(
                          context,
                          EventDetailScreen(
                              event: event, uniqueId: _uniqueId, user: user));
                    }),
                // Share button.
                Align(
                    alignment: Alignment.topRight, child: _buttonShare(context))
              ]),
            ),
            // Event image.
            _eventImage(context)
          ],
        ),
      ),
    );
  }

  /// Event information.
  Widget _eventInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Date event.
        _dateEvent(context),
        SizedBox(height: screenAwareHeight(7, context)),
        // Event title.
        _titleEvent(context),
        SizedBox(height: screenAwareHeight(7, context)),
        // Event location.
        _eventLocation(context),
        SizedBox(height: screenAwareHeight(7, context)),
        // Event hour.
        _eventHour(context)
      ],
    );
  }

  /// Returns the date event.
  Widget _dateEvent(BuildContext context) {
    final _date = Jiffy(
            DateTime.fromMillisecondsSinceEpoch(
                event.startDateTime.millisecondsSinceEpoch),
            "yyyy-MM-dd")
        .format("MMM do, yyyy");

    return Text(
      _date,
      style: TextStyle(
        color: Color(0xff000000),
        fontSize: screenAwareWidth(10, context),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
    );
  }

  /// Returns the event title.
  Widget _titleEvent(BuildContext context) {
    return Text(
      event.eventName,
      style: TextStyle(
        color: Color(0xff060110),
        fontSize: screenAwareWidth(14, context),
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      ),
    );
  }

  /// Returns the event location.
  Widget _eventLocation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Location icon.
        SvgPicture.asset("assets/location.svg",
            fit: BoxFit.fill,
            width: screenAwareWidth(15, context),
            height: screenAwareWidth(15, context)),
        SizedBox(width: screenAwareWidth(2, context)),
        // Event location.
        Text(
          event.location,
          style: TextStyle(
            color: Color(0x99000000),
            fontSize: screenAwareWidth(10, context),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        )
      ],
    );
  }

  /// Returns the event hour.
  Widget _eventHour(BuildContext context) {
    final _startHour = Jiffy(
            DateTime.fromMillisecondsSinceEpoch(
                event.startDateTime.millisecondsSinceEpoch),
            "yyyy-MM-dd hh:mm:ss")
        .format("hh:mm a");
    final _endHour = Jiffy(
            DateTime.fromMillisecondsSinceEpoch(
                event.endDateTime.millisecondsSinceEpoch),
            "yyyy-MM-dd hh:mm:ss")
        .format("hh:mm a");

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Location icon.
        SvgPicture.asset("assets/clock.svg",
            fit: BoxFit.fill,
            width: screenAwareWidth(15, context),
            height: screenAwareWidth(15, context)),
        SizedBox(width: screenAwareWidth(2, context)),
        // Event location.
        Text(
          "$_startHour - $_endHour",
          style: TextStyle(
            color: Color(0x99000000),
            fontSize: screenAwareWidth(10, context),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        )
      ],
    );
  }

  /// Return the button share.
  Widget _buttonShare(BuildContext context) {
    return InkWell(
      child: ClipOval(
        child: Container(
          width: screenAwareWidth(35, context),
          height: screenAwareWidth(35, context),
          color: Theme.of(context).primaryColor,
          child: Center(
            child: SvgPicture.asset(
              "assets/share.svg",
              fit: BoxFit.fitWidth,
              width: screenAwareWidth(25, context),
            ),
          ),
        ),
      ),
      onTap: () {
        /// Share button pressed action.
        Share.share(
          "Participate in the event ${event.eventName} with this link https://www.postalup.com/",
        );
      },
    );
  }

  /// Returns the event image.
  Widget _eventImage(BuildContext context) {
    return InkWell(
      child: Container(
          width: double.infinity,
          height: screenAwareHeight(160, context),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: FadeInImage(
                fit: BoxFit.fitWidth,
                placeholder: AssetImage("assets/load.gif"),
                image: NetworkImage(event.eventImageUrl ??
                    "https://media.graytvinc.com/images/690*388/Holiday+shipping+12+12.JPG")),
          )),
      onTap: () {
        navigateTo(context,
            EventDetailScreen(event: event, uniqueId: _uniqueId, user: user));
      },
    );
  }
}
