import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teachme/models/office.dart';
import 'package:teachme/models/profile.dart';
import 'package:teachme/models/status.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/models/voclients.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/ui/widgets/page_header.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

/// Filter screen.
///
/// Page where you select the filters for the emails you want to see.
class FilterScreen extends StatefulWidget {
  // List of filters already applied.
  final Map<String, dynamic> filtersApplied;
  // Status type indicator.
  final bool isForEvent;
  // Current user.
  final User user;

  FilterScreen(
      {@required this.filtersApplied,
      @required this.isForEvent,
      @required this.user});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Offices map
  Map<String, String> _officeMap = {};
  // Office id selected.
  String _officeId;
  // Office selected.
  String _status;
  // Start date controller.
  TextEditingController _startDateController = new TextEditingController();
  // Start date selected.
  DateTime _startDate = DateTime.now();
  // End date controller.
  TextEditingController _endDateController = new TextEditingController();
  // End date selected.
  DateTime _endDate = DateTime.now();
  // Scaffold key.
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Only if there are filters applied.
    if (widget.filtersApplied.length > 0) {
      final _dates = widget.filtersApplied["Date"];

      // Only if there is a date filter.
      if (_dates != null) {
        final _dates = widget.filtersApplied["Date"];

        _startDate =
            DateTime.parse(Map.castFrom(_dates)["StartDate"].toString());
        _endDate = DateTime.parse(Map.castFrom(_dates)["EndDate"].toString());
        _startDateController.text =
            Jiffy(_startDate, "yyyy-MM-dd").format("MMM do, yyyy");
        _endDateController.text =
            Jiffy(_endDate, "yyyy-MM-dd").format("MMM do, yyyy");
      }

      // Set the filters applied.
      _officeId = widget.filtersApplied["Office"] != null
          ? Map.castFrom(widget.filtersApplied["Office"])
              .entries
              .first
              .key
              .toString()
          : null;
      _status = widget.filtersApplied["Status"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Page header.
            _pageHeader(context),
            SizedBox(height: screenAwareHeight(40, context)),
            // Office drop down list.
            _officeFilter(context),
            SizedBox(height: screenAwareHeight(20, context)),
            // Start date filter.
            _startDateFilter(context),
            SizedBox(height: screenAwareHeight(20, context)),
            // End date filter.
            _endDateFilter(context),
            SizedBox(height: screenAwareHeight(20, context)),
            // Status filter.
            _statusFilter(context),
            SizedBox(height: screenAwareHeight(50, context)),
            // Filter buttons.
            _actionButtons(context)
          ],
        ),
      ),
    );
  }

  /// Return the page header with arrow to go
  /// back and the title page.
  Widget _pageHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: screenAwareHeight(25, context),
          bottom: screenAwareHeight(30, context)),
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: PageHeader(
        color: Theme.of(context).buttonColor,
        fontWeight: FontWeight.bold,
        arrowSize: screenAwareWidth(25, context),
        fontSize: screenAwareWidth(18, context),
        title: "Filters",
      ),
    );
  }

  /// Returns the drop down list
  /// for the office filter.
  Widget _officeFilter(BuildContext context) {
    final _emptyList = DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xff000000)),
        value: "",
        onChanged: (value) {},
        items: [
          DropdownMenuItem(child: Text(""), value: ""),
        ],
      ),
    );

    // Returns the office filter
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Office",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(10, context)),
          // Drop down list office.
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: screenAwareWidth(10, context)),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder<List<VOClients>>(
              stream: Provider.of<DatabaseService>(context)
                  .streamVOClients(widget.user.email),
              builder: (BuildContext _context,
                  AsyncSnapshot<List<VOClients>> officeSnapshot) {
                if (!officeSnapshot.hasData) {
                  return _emptyList;
                } else {
                  return StreamBuilder<Map<String, String>>(
                    stream: Provider.of<DatabaseService>(context)
                        .getOfficeFilter(officeSnapshot.data),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, String>> filterSnapshot) {
                      if (!filterSnapshot.hasData) {
                        return _emptyList;
                      } else {
                        if (filterSnapshot.data.length > 0) {
                          _officeMap = filterSnapshot.data;

                          return DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: Color(0xff000000)),
                              value: _officeId ?? filterSnapshot.data[0],
                              onChanged: (value) {
                                _officeId = value;
                                setState(() {});
                              },
                              items: filterSnapshot.data.entries
                                  .map(
                                    (office) => DropdownMenuItem(
                                      child: Text(
                                        office.key,
                                        style: TextStyle(
                                          color: Color(0x7f060110),
                                          fontSize:
                                              screenAwareWidth(12, context),
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      value: office.key,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        } else {
                          return _emptyList;
                        }
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the start date picker.
  Widget _startDateFilter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Start Date",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(10, context)),
          // Start date picker.
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _startDateController,
                enabled: false,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    color: Color(0x7f060110),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: screenAwareWidth(10, context)),
                  border: InputBorder.none,
                  suffixIcon:
                      Icon(Icons.keyboard_arrow_down, color: Color(0xff000000)),
                ),
              ),
            ),
            onTap: () {
              _showStartDatePicker(context);
            },
          )
        ],
      ),
    );
  }

  /// Show the start date picker.
  void _showStartDatePicker(BuildContext context) async {
    // Theme data.
    final _theme = Theme.of(context);

    DateTime _date = await showRoundedDatePicker(
        description: "Start Date",
        context: context,
        barrierDismissible: true,
        initialDate: _startDate,
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime(DateTime.now().year + 10),
        initialDatePickerMode: DatePickerMode.day,
        locale: Locale('en', 'US'),
        borderRadius: 20,
        styleDatePicker: _datePickerStyle(context, _theme),
        theme: ThemeData(
            primaryColor: _theme.primaryColor,
            accentColor: _theme.primaryColor.withOpacity(0.4)));

    //Setea fecha al input de fecha nacimiento.
    if (_date != null) {
      _startDate = _date;
      _startDateController.text =
          Jiffy(_date.toString(), "yyyy-MM-dd").format("MMM do, yyyy");

      setState(() {});
    }
  }

  /// Returns the end date picker.
  Widget _endDateFilter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "End Date",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(10, context)),
          // End date picker.
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _endDateController,
                enabled: false,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    color: Color(0x7f060110),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenAwareWidth(10, context),
                  ),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),
            onTap: () {
              _showEndDatePicker(context);
            },
          )
        ],
      ),
    );
  }

  /// Show the end date picker.
  void _showEndDatePicker(BuildContext context) async {
    // Theme data.
    final _theme = Theme.of(context);

    DateTime _date = await showRoundedDatePicker(
      description: "End Date",
      context: context,
      barrierDismissible: true,
      initialDate: _endDate,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDatePickerMode: DatePickerMode.day,
      locale: Locale('en', 'US'),
      borderRadius: 20,
      styleDatePicker: _datePickerStyle(context, _theme),
      theme: ThemeData(
        primaryColor: _theme.primaryColor,
        accentColor: _theme.primaryColor.withOpacity(0.4),
      ),
    );

    //Setea fecha al input de fecha nacimiento.
    if (_date != null) {
      _endDate = _date;
      _endDateController.text =
          Jiffy(_date.toString(), "yyyy-MM-dd").format("MMM do, yyyy");

      setState(() {});
    }
  }

  /// Returns the date picker style.
  MaterialRoundedDatePickerStyle _datePickerStyle(
      BuildContext context, ThemeData theme) {
    return MaterialRoundedDatePickerStyle(
      paddingActionBar: EdgeInsets.all(0),
      paddingMonthHeader: EdgeInsets.all(13),
      textStyleButtonPositive: TextStyle(
        fontSize: screenAwareWidth(14, context),
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: theme.primaryColor,
      ),
      textStyleButtonNegative: TextStyle(
        fontSize: screenAwareWidth(14, context),
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: theme.primaryColor,
      ),
      decorationDateSelected: BoxDecoration(
        color: theme.primaryColor,
        shape: BoxShape.circle,
      ),
      textStyleDayOnCalendarSelected: TextStyle(color: Colors.white),
      textStyleCurrentDayOnCalendar: TextStyle(
        color: Color(0xffed8332),
      ),
    );
  }

  /// Returns the drop down list
  /// for the stauts filter.
  Widget _statusFilter(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Status",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: screenAwareWidth(14, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(
                height: screenAwareHeight(10, context),
              ),
              // Drop down list stauts.
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(10, context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StreamBuilder<List<Status>>(
                  stream: Provider.of<DatabaseService>(context)
                      .getStreamStatus(isForEvent: widget.isForEvent),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Status>> snapshot) {
                    if (!snapshot.hasData) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          onChanged: (value) {},
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xff000000),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: "",
                              child: Text(""),
                            )
                          ],
                        ),
                      );
                    } else {
                      List<Status> _list = snapshot.data;
                      _list.sort((a, b) => a.status.compareTo(b.status));

                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xff000000),
                          ),
                          value: _status ?? _list[0].status,
                          onChanged: (value) {
                            _status = value;
                            setState(() {});
                          },
                          items: _list
                              .map(
                                (status) => DropdownMenuItem(
                                  child: Text(
                                    status.status,
                                    style: TextStyle(
                                      color: Color(0x7f060110),
                                      fontSize: screenAwareWidth(12, context),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  value: status.status,
                                ),
                              )
                              .toList(),
                        ),
                      );
                    }
                  },
                ),
              )
            ]));
  }

  /// Return the action buttons.
  Widget _actionButtons(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      color: Colors.transparent,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Clear filter button.
            _clearButton(context),
            SizedBox(width: screenAwareWidth(17, context)),
            // Filter button.
            _filterButton(context)
          ]),
    );
  }

  /// Returns the filter button.
  Widget _filterButton(BuildContext context) {
    return Center(
      child: MainButton(
          isLoading: false,
          enabledColor: Color(0xff060110),
          enabled: true,
          width: screenAwareWidth(145, context),
          height: screenAwareHeight(48, context),
          child: Text("Filter",
              style: TextStyle(
                  color: Color(0xfffefefe),
                  fontSize: screenAwareWidth(16, context),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal)),
          onTap: () {
            _setFilters(context);
          }),
    );
  }

  /// Return the login button.
  Widget _clearButton(BuildContext context) {
    return MainButton(
        isLoading: false,
        child: Text("Clear",
            style: TextStyle(
                color: Color(0xfffefefe),
                fontSize: screenAwareWidth(16, context),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal)),
        enabled: true,
        width: screenAwareWidth(145, context),
        height: screenAwareHeight(48, context),
        enabledColor: Theme.of(context).primaryColor,
        onTap: _clearFilters);
  }

  /// Sets the selected filters.
  void _setFilters(BuildContext context) {
    if (_startDate.isAfter(_endDate)) {
      final _snack = new SnackBar(
          content: Text("Start date must be before end date.",
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: screenAwareWidth(12, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal)));

      _scaffoldKey.currentState.showSnackBar(_snack);
    } else {
      Map<String, dynamic> _filterList = {};

      if (_officeId != null && _officeId != "")
        _filterList.addAll(
          <String, dynamic>{
            "Office": {
              _officeId: _officeMap[_officeId],
            },
          },
        );

      if (_startDateController.text != "" && _endDateController.text != "")
        _filterList.addAll(<String, dynamic>{
          "Date": {
            "StartDate": _startDate,
            "EndDate": _endDate
                .add(Duration(hours: 23))
                .add(Duration(minutes: 59))
                .add(Duration(seconds: 59))
          }
        });

      if (_status != null && _status != "")
        _filterList.addAll(<String, dynamic>{"Status": _status});

      // Response filters.
      Navigator.of(context).pop(_filterList);
    }
  }

  /// Reset filters.
  void _clearFilters() {
    _officeId = null;
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _startDateController.text = "";
    _endDateController.text = "";
    _status = null;
    setState(() {});
  }
}
