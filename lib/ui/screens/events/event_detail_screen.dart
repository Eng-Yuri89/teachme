import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_calendar/device_calendar.dart' as deviceCalendar;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teachme/models/event.dart';
import 'package:teachme/ui/widgets/circle_button.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/ui/widgets/page_header.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';
import 'package:share/share.dart';
import 'package:teachme/ui/screens/events/send_message_screen.dart';
import 'package:provider/provider.dart';
import 'package:teachme/models/user.dart';

/// Event detail screen.
///
/// Returns the screen with the detail of the
/// event selected.
class EventDetailScreen extends StatefulWidget {
  // Event selected.
  final Event event;
  // Hero animation unique id.
  final String uniqueId;
  // User conected.
  final User user;

  EventDetailScreen(
      {@required this.event, @required this.uniqueId, @required this.user});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  // Scaffold key.
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // List of calendars.
  List<deviceCalendar.Calendar> _calendars;
  // Calendar plugin.
  deviceCalendar.DeviceCalendarPlugin _deviceCalendarPlugin =
      new deviceCalendar.DeviceCalendarPlugin();

  @override
  void initState() {
    super.initState();

    // Get device calendars.
    _getCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
              // Page header.
              _pageHeader(context),
              // Event image.
              _eventImage(context),
              SizedBox(height: screenAwareHeight(55, context)),
              // Event date.
              _eventDate(context),
              SizedBox(height: screenAwareHeight(20, context)),
              // Event title.
              _titleEvent(context),
              SizedBox(height: screenAwareHeight(20, context)),
              // Event location.
              _eventLocation(context),
              SizedBox(height: screenAwareHeight(8, context)),
              // Event hour.
              _eventHour(context),
              SizedBox(height: screenAwareHeight(25, context)),
              // Event description.
              _eventDescription(context),
              SizedBox(height: screenAwareHeight(40, context)),
              // Register button.
              _saveButton(context)
            ]))));
  }

  /// Returns the page header.
  Widget _pageHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenAwareWidth(30, context)),
      child: PageHeader(
        color: Theme.of(context).buttonColor,
        fontWeight: FontWeight.bold,
        arrowSize: screenAwareWidth(25, context),
        fontSize: screenAwareWidth(18, context),
        title: "Event Detail",
      ),
    );
  }

  /// Returns the event image.
  Widget _eventImage(BuildContext context) {
    return Hero(
      tag: widget.uniqueId,
      child: FadeInImage(
        width: double.infinity,
        height: screenAwareHeight(230, context),
        fit: BoxFit.fitWidth,
        placeholder: AssetImage("assets/load.gif"),
        image: NetworkImage(
          widget.event.eventImageUrl ??
              "https://media.graytvinc.com/images/690*388/Holiday+shipping+12+12.JPG",
        ),
      ),
    );
  }

  /// Returns the event date.
  Widget _eventDate(BuildContext context) {
    final _date = Jiffy(
            DateTime.fromMillisecondsSinceEpoch(
                widget.event.startDateTime.millisecondsSinceEpoch),
            "yyyy-MM-dd")
        .format("MMM do, yyyy");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Event date.
          Text(
            _date,
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(10, context),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
          // Event actions.
          _eventActions(context)
        ],
      ),
    );
  }

  /// Returns the actions of the event.
  Widget _eventActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Calendar event action button.
        CircleButton(
          radius: screenAwareWidth(35, context),
          backgroundColor: Theme.of(context).primaryColor,
          child: Center(
            child: SvgPicture.asset("assets/event_calendar.svg",
                fit: BoxFit.fitWidth, width: screenAwareWidth(20, context)),
          ),
          onTap: () {
            _showModalCalendar(context);
          },
        ),
        SizedBox(width: screenAwareWidth(6, context)),
        // Share event action button.
        CircleButton(
          radius: screenAwareWidth(35, context),
          backgroundColor: Theme.of(context).primaryColor,
          child: Center(
            child: SvgPicture.asset(
              "assets/share.svg",
              fit: BoxFit.fitWidth,
              width: screenAwareWidth(25, context),
            ),
          ),
          onTap: _shareEvent,
        ),
      ],
    );
  }

  /// Returns the event title.
  Widget _titleEvent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: AutoSizeText(widget.event.eventName,
          maxLines: 1,
          style: TextStyle(
              color: Color(0xff060110),
              fontSize: screenAwareWidth(20, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal)),
    );
  }

  /// Returns the event location.
  Widget _eventLocation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        // Location icon.
        SvgPicture.asset("assets/location.svg",
            fit: BoxFit.fill,
            width: screenAwareWidth(18, context),
            height: screenAwareWidth(18, context)),
        SizedBox(width: screenAwareWidth(7, context)),
        // Event location.
        Text(widget.event.location,
            style: TextStyle(
                color: Color(0x99000000),
                fontSize: screenAwareWidth(10, context),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal))
      ]),
    );
  }

  /// Returns the event hour.
  Widget _eventHour(BuildContext context) {
    final _startHour = Jiffy(
            DateTime.fromMillisecondsSinceEpoch(
                widget.event.startDateTime.millisecondsSinceEpoch),
            "yyyy-MM-dd hh:mm:ss")
        .format("hh:mm a");
    final _endHour = Jiffy(
            DateTime.fromMillisecondsSinceEpoch(
                widget.event.endDateTime.millisecondsSinceEpoch),
            "yyyy-MM-dd hh:mm:ss")
        .format("hh:mm a");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        // Location icon.
        SvgPicture.asset("assets/clock.svg",
            fit: BoxFit.fill,
            width: screenAwareWidth(18, context),
            height: screenAwareWidth(18, context)),
        SizedBox(width: screenAwareWidth(7, context)),
        // Event location.
        Text("$_startHour - $_endHour",
            style: TextStyle(
                color: Color(0x99000000),
                fontSize: screenAwareWidth(10, context),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal))
      ]),
    );
  }

  /// Returns the event description.
  Widget _eventDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Description",
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal)),
            SizedBox(height: screenAwareHeight(10, context)),
            Text(widget.event.description,
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal))
          ]),
    );
  }

  /// Register button.
  Widget _saveButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Center(
        child: MainButton(
            isLoading: false,
            enabledColor: Theme.of(context).primaryColor,
            child: Text("REGISTER",
                style: TextStyle(
                  color: Color(0xfffefefe),
                  fontSize: screenAwareWidth(16, context),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
            enabled: true,
            width: screenAwareWidth(282, context),
            height: screenAwareHeight(50, context),
            onTap: () {
              _goToSendMessageScreen(context);
            }),
      ),
    );
  }

  /// Share button pressed action.
  void _shareEvent() {
    Share.share(
      "Participate in the event ${widget.event.eventName} with this link https://www.postalup.com/",
    );
  }

  /// Add to calendar button pressed.
  /// Display the modal window.
  void _showModalCalendar(BuildContext context) {
    // Modal dialog
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: screenAwareHeight(210, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenAwareWidth(24, context),
            vertical: screenAwareHeight(17, context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Modal title
              Text(
                "Save to your Calendar",
                style: TextStyle(
                  color: Theme.of(context).buttonColor,
                  fontSize: screenAwareWidth(18, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: screenAwareHeight(5, context)),
              // Divider
              Divider(color: Color(0x7fc4c4c4), thickness: 1.5),
              SizedBox(height: screenAwareHeight(10, context)),
              // Calendars list.
              _calendarListWidtet(context)
            ],
          ),
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  /// Get the devices calendars.
  void _getCalendars() async {
    try {
      // Valid if permits have already been granted.
      var _permissionGranted = await _deviceCalendarPlugin.hasPermissions();

      // If they have not been granted, permission is requested.
      if (_permissionGranted.isSuccess && !_permissionGranted.data) {
        _permissionGranted = await _deviceCalendarPlugin.requestPermissions();

        // If they have already been awarded, nothing is done.
        if (!_permissionGranted.isSuccess || !_permissionGranted.data) {
          return;
        }
      }

      // Get the calendars.
      final _calendarRetults = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = _calendarRetults?.data;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  /// Returns the list view with calendars.
  Widget _calendarListWidtet(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Calendar logo.
                      SvgPicture.asset(
                        "assets/calendar.svg",
                        fit: BoxFit.fill,
                        width: screenAwareWidth(18.5, context),
                      ),
                      SizedBox(width: screenAwareWidth(10, context)),
                      Flexible(
                        child: AutoSizeText(_calendars[index].name,
                            maxLines: 1,
                            style: TextStyle(
                                color: Color(0xff060110),
                                fontSize: screenAwareWidth(18, context),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal)),
                      )
                    ]),
                onTap: () {
                  _addCalendar(_calendars[index], context);
                });
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: screenAwareHeight(20, context));
          },
          itemCount: _calendars.length),
    );
  }

  /// Add event to the calendar.
  void _addCalendar(
      deviceCalendar.Calendar calendar, BuildContext context) async {
    deviceCalendar.Event _event = new deviceCalendar.Event(calendar.id);
    _event.allDay = false;
    _event.title = widget.event.eventName;
    _event.description = widget.event.description;
    _event.start = DateTime.fromMillisecondsSinceEpoch(
        widget.event.startDateTime.millisecondsSinceEpoch);
    _event.end = DateTime.fromMillisecondsSinceEpoch(
        widget.event.endDateTime.millisecondsSinceEpoch);
    _event.location = widget.event.location;

    // Add event to the calendar.
    final _result = await _deviceCalendarPlugin.createOrUpdateEvent(_event);

    final _message = _result.isSuccess
        ? "Event added to the calendar."
        : "The event could not be added.";

    final _snack = new SnackBar(
        content: Text(_message,
            style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: screenAwareWidth(12, context),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal)));

    // Close modal window.
    Navigator.of(context, rootNavigator: true).pop('dialog');
    // Notify result.
    _scaffoldKey.currentState.showSnackBar(_snack);
  }

  /// Go to send message screen.
  void _goToSendMessageScreen(BuildContext context) async {
    final _response = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SendMessageScreenHeader(user: widget.user)),
    );

    if (_response != null) {
      if (_response == true) {
        final _snack = new SnackBar(
            content: Text("Message sent successfully.",
                style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal)));

        _scaffoldKey.currentState.showSnackBar(_snack);
      }
    }
  }
}
