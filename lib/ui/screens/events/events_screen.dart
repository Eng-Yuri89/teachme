import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teachme/models/event.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/models/voclients.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/screens/home/filter_screen.dart';
import 'package:teachme/ui/widgets/event_card.dart';
import 'package:teachme/ui/widgets/screen_header.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

/// All events screen.
///
/// Page where all the evetns are shown.
class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // Filters selected list.
  Map<String, dynamic> _filterSelectedList = {};
  // Filter input controller
  TextEditingController _filterController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<User>(
          builder: (BuildContext conContext, User user, Widget child) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Page header.
                _pageHeader(conContext),
                // Filter selector.
                _filterInput(conContext, user),
                SizedBox(height: screenAwareHeight(15, conContext)),
                // Filters selected list.
                _filtersList(conContext),
                SizedBox(height: screenAwareHeight(18.7, conContext)),
                // Events result list.
                _eventsResultList(conContext, user),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Return the page header with arrow to go
  /// back and the title page.
  Widget _pageHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: screenAwareHeight(30, context)),
      child: ScreenHeader(title: 'Events'),
    );
  }

  /// Return the filter widget.
  Widget _filterInput(BuildContext context, User user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(15, context),
        ),
        height: screenAwareHeight(50, context),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(127, 128, 132, 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Search icon.
            SvgPicture.asset(
              "assets/search.svg",
              fit: BoxFit.fill,
              width: screenAwareHeight(25, context),
            ),
            SizedBox(width: screenAwareWidth(10, context)),
            // Filter text or filters selected.
            Expanded(
              child: TextFormField(
                controller: _filterController,
                autofocus: false,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  suffixIcon: _filterController.text == ""
                      ? Container(width: 0, height: 0)
                      : InkWell(
                          child: Icon(Icons.close),
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                _filterController.clear();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {});
                              },
                            );
                          },
                        ),
                  contentPadding: EdgeInsets.fromLTRB(
                    0,
                    screenAwareHeight(20, context),
                    screenAwareWidth(10, context),
                    screenAwareHeight(20, context),
                  ),
                  border: InputBorder.none,
                  hintText: "Search by name or keyword",
                  hintStyle: TextStyle(
                    color: Color(0x7f060110),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            // Filter icon.
            InkWell(
              child: SvgPicture.asset("assets/filter.svg",
                  fit: BoxFit.fill, width: screenAwareHeight(25, context)),
              onTap: () {
                _goToFilter(context, user);
              },
            )
          ],
        ),
      ),
    );
  }

  /// Returns the filters selected.
  Widget _filtersList(BuildContext context) {
    if (_filterSelectedList.length == 0) {
      return Container();
    }

    // Filters list.
    return Container(
      height: screenAwareHeight(40, context),
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(30, context),
        vertical: screenAwareHeight(7, context),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filterSelectedList.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: screenAwareWidth(10, context));
        },
        itemBuilder: (BuildContext context, int index) {
          return _filterCard(context,
              _filterSelectedList[_filterSelectedList.keys.elementAt(index)]);
        },
      ),
    );
  }

  /// Returns the card for each selected filter.
  Widget _filterCard(BuildContext context, dynamic filter) {
    // Filter text.
    String _textFilter;

    if (filter is Map) {
      if (Map.castFrom(filter)["StartDate"] != null) {
        final _startDate =
            DateTime.parse(Map.castFrom(filter)["StartDate"].toString());
        final _endDate =
            DateTime.parse(Map.castFrom(filter)["EndDate"].toString());
        _textFilter =
            "${Jiffy(_startDate, "yyyy-MM-dd").format("MM.dd.yyyy")} - ${Jiffy(_endDate, "yyyy-MM-dd").format("MM.dd.yyyy")}";
      } else {
        _textFilter = Map.castFrom(filter).entries.first.key;
      }
    } else {
      _textFilter = filter.toString();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(10, context)),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          _textFilter.toUpperCase(),
          maxLines: 1,
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: screenAwareWidth(10, context),
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }

  /// Returns the list header.
  Widget _listHeader(BuildContext context, int results) {
    if (_filterSelectedList.length == 0 && _filterController.text == "") {
      return Text(
        "Last Events",
        style: TextStyle(
          color: Theme.of(context).buttonColor,
          fontSize: screenAwareWidth(20, context),
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      );
    }

    // Filter count.
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Filter Results",
          style: TextStyle(
            color: Theme.of(context).buttonColor,
            fontSize: screenAwareWidth(20, context),
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
        SizedBox(width: screenAwareWidth(5, context)),
        Text(
          "($results results)",
          style: TextStyle(
            color: Theme.of(context).buttonColor,
            fontSize: screenAwareWidth(12, context),
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
          ),
        )
      ],
    );
  }

  /// Returns the event list
  Widget _eventsResultList(BuildContext context, User user) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: StreamBuilder<List<VOClients>>(
            stream: Provider.of<DatabaseService>(context)
                .streamVOClients(user.email),
            builder: (BuildContext context,
                AsyncSnapshot<List<VOClients>> officeSnapshot) {
              if (!officeSnapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(height: screenAwareHeight(20, context)),
                    Center(
                      child: CircularProgressIndicator(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.4),
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return officeSnapshot.data.length > 0
                    ? _fullResults(context, officeSnapshot.data, user)
                    : _emptyResults(context);
              }
            },
          ),
        ),
      ),
    );
  }

  /// Retunrs the all evens of the user by offices.
  Widget _fullResults(
      BuildContext context, List<VOClients> offices, User user) {
    return StreamBuilder<List<Event>>(
      stream: Provider.of<DatabaseService>(context).getEventsByOffices(offices),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        // Child of the column.
        Widget _child;

        // If no has data.
        if (!snapshot.hasData) {
          _child = Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).primaryColor,
              ),
            ),
          );
        } else {
          if (snapshot.data.length == 0) {
            _child = Column(
              children: [
                SizedBox(height: screenAwareHeight(160, context)),
                Center(
                  child: Text('No Events (0)'),
                ),
              ],
            );
          } else {
            // Event list.
            List<Event> _list = snapshot.data;
            // Text filter.
            final _filter = _filterController.text.toUpperCase();

            if (_filterSelectedList.length > 0 || _filter != "") {
              final _office = _filterSelectedList["Office"] != null
                  ? _filterSelectedList["Office"]
                  : null;
              final _status = _filterSelectedList["Status"] != null
                  ? _filterSelectedList["Status"].toString().toUpperCase()
                  : null;
              final _dates = _filterSelectedList["Date"] != null
                  ? Map.castFrom(_filterSelectedList["Date"])
                  : null;
              final _startDate = _dates != null
                  ? DateTime.parse(_dates["StartDate"].toString())
                  : null;
              final _endDate = _dates != null
                  ? DateTime.parse(_dates["EndDate"].toString())
                  : null;

              _list = _getFilteredList(
                snapshot.data,
                _office != null
                    ? Map.castFrom(_office).entries.first.value.toString()
                    : null,
                _status,
                _startDate,
                _endDate,
                _filter,
              );
            } else {
              _list = _getRecentList(snapshot.data);
            }

            _child = _list.length > 0
                ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: _list.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: screenAwareHeight(20, context));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return EventCard(event: snapshot.data[index], user: user);
                    })
                : Column(
                    children: [
                      SizedBox(height: screenAwareHeight(160, context)),
                      Center(
                        child: Text('No Events (0)'),
                      ),
                    ],
                  );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // List header.
                _listHeader(context, _list.length),
                SizedBox(height: screenAwareHeight(5, context)),
                _child
              ],
            );
          }
        }

        return Container();
      },
    );
  }

  /// Empty results.
  Widget _emptyResults(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenAwareHeight(50, context)),
        Center(
          child: SvgPicture.asset(
            "assets/empty.svg",
            fit: BoxFit.fill,
            width: screenAwareWidth(253, context),
            height: screenAwareHeight(198, context),
          ),
        ),
        SizedBox(height: screenAwareHeight(80, context)),
        // Help text information.
        Center(
          child: Text(
            "You don’t have offices yet, please \ncontact you office administration ",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(16, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
        )
      ],
    );
  }

  /// Go to filter screen and wait the response
  /// to filter mail information.z
  void _goToFilter(BuildContext context, User user) async {
    // Focus remove.
    FocusScope.of(context).requestFocus(new FocusNode());

    final _filter = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilterScreen(
          filtersApplied: _filterSelectedList,
          isForEvent: true,
          user: user,
        ),
      ),
    );

    if (_filter != null) {
      _filterSelectedList.clear();
      _filterSelectedList.addAll(_filter);
      setState(() {});
    }
  }

  /// Get the filtered list of events.
  List<Event> _getFilteredList(List<Event> listEvent, String office,
      String status, DateTime startDate, DateTime endDate, String filter) {
    List<Event> _filteredList = listEvent
        .where((event) => ((filter != ""
                ? event.description.toUpperCase().contains(filter) ||
                    event.eventName.toUpperCase().contains(filter) ||
                    event.location.toUpperCase().contains(filter) ||
                    event.officeID.toUpperCase().contains(filter) ||
                    event.status.toUpperCase().contains(filter)
                : true) &&
            ((office != null
                    ? event.officeID.toUpperCase() == office.toUpperCase()
                    : true) &&
                (status != null
                    ? event.status.toUpperCase() == status
                    : true) &&
                (startDate != null
                    ? startDate.isBefore(DateTime.fromMillisecondsSinceEpoch(
                            event.startDateTime.millisecondsSinceEpoch)) &&
                        endDate.isAfter(
                            DateTime.fromMillisecondsSinceEpoch(event.endDateTime.millisecondsSinceEpoch))
                    : true))))
        .toList();

    return _filteredList;
  }

  /// Get the recent events list.
  List<Event> _getRecentList(List<Event> listEvent) {
    final _date = new DateTime.now();
    final _startDate = new DateTime(_date.year, _date.month, _date.day - 3);
    final _endDate = new DateTime(_date.year, _date.month, _date.day)
        .add(Duration(hours: 23))
        .add(Duration(minutes: 59))
        .add(Duration(seconds: 59));

    List<Event> _filteredList = listEvent
        .where((event) => (_startDate.isBefore(
                DateTime.fromMillisecondsSinceEpoch(
                    event.startDateTime.millisecondsSinceEpoch)) &&
            _endDate.isAfter(DateTime.fromMillisecondsSinceEpoch(
                event.endDateTime.millisecondsSinceEpoch))))
        .toList();

    return _filteredList;
  }
}
