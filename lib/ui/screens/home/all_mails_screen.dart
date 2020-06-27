import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teachme/models/mail.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/models/voclients.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/screens/home/filter_screen.dart';
import 'package:teachme/ui/widgets/mail_card.dart';
import 'package:teachme/ui/widgets/page_header.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

/// All mail screen.
///
/// Page where all the mails are shown.
class AllMailScreen extends StatefulWidget {
  // User conected.
  final User user;
  // Offices user list.
  final List<VOClients> offices;

  AllMailScreen({@required this.user, @required this.offices});

  @override
  _AllMailScreenState createState() => _AllMailScreenState();
}

class _AllMailScreenState extends State<AllMailScreen> {
  // Filters selected list.
  Map<String, dynamic> _filterSelectedList = {};
  // Filter input controller
  TextEditingController _filterController = new TextEditingController();

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
            // Filter selector.
            _filterInput(context),
            SizedBox(height: screenAwareHeight(15, context)),
            // Filters selected list.
            _filtersList(context),
            SizedBox(height: screenAwareHeight(18.7, context)),
            // Mail result list.
            _mailResultList(context)
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
        bottom: screenAwareHeight(30, context),
      ),
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: PageHeader(
        color: Theme.of(context).buttonColor,
        fontWeight: FontWeight.bold,
        arrowSize: screenAwareWidth(25, context),
        fontSize: screenAwareWidth(18, context),
        title: "All Mail",
      ),
    );
  }

  /// Return the filter widget.
  Widget _filterInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(30, context),
      ),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(15, context)),
        height: screenAwareHeight(50, context),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(127, 128, 132, 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Search icon.
            SvgPicture.asset("assets/search.svg",
                fit: BoxFit.fill, width: screenAwareHeight(25, context)),
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
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _filterController.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {});
                            });
                          }),
                  contentPadding: EdgeInsets.fromLTRB(
                      0,
                      screenAwareHeight(20, context),
                      screenAwareWidth(10, context),
                      screenAwareHeight(20, context)),
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
                _goToFilter(context);
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
          borderRadius: BorderRadius.circular(100)),
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
        "Last Mail",
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

  /// Returns the mail list
  Widget _mailResultList(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: StreamBuilder<List<Mail>>(
            stream: Provider.of<DatabaseService>(context)
                .getMailByOficess(widget.offices),
            builder:
                (BuildContext context, AsyncSnapshot<List<Mail>> snapshot) {
              // Child of the results of mail.
              Widget _child;

              // If no has data.
              if (!snapshot.hasData) {
                _child = Center(
                  child: CircularProgressIndicator(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.4),
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
                        child: Text('No Mail (0)'),
                      ),
                    ],
                  );
                } else {
                  // Mail list.
                  List<Mail> _list = snapshot.data;
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
                            return SizedBox(
                                height: screenAwareHeight(20, context));
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return MailCard(mail: _list[index]);
                          },
                        )
                      : Column(
                          children: [
                            SizedBox(height: screenAwareHeight(160, context)),
                            Center(
                              child: Text('No Mail (0)'),
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
                      _child,
                    ],
                  );
                }
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  /// Go to filter screen and wait the response
  /// to filter mail information.
  void _goToFilter(BuildContext context) async {
    // Focus remove.
    FocusScope.of(context).requestFocus(new FocusNode());

    final _filter = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilterScreen(
          filtersApplied: _filterSelectedList,
          isForEvent: false,
          user: widget.user,
        ),
      ),
    );

    if (_filter != null) {
      _filterSelectedList.clear();
      _filterSelectedList.addAll(_filter);
      // Focus remove.
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {});
    }
  }

  /// Get the filtered list of mails.
  List<Mail> _getFilteredList(List<Mail> listMail, String office, String status,
      DateTime startDate, DateTime endDate, String filter) {
    List<Mail> _filteredList = listMail
        .where((mail) => ((filter != ""
                ? mail.owner.toUpperCase().contains(filter) ||
                    mail.ownerName.toUpperCase().contains(filter) ||
                    mail.description.toUpperCase().contains(filter) ||
                    mail.office.toUpperCase().contains(filter) ||
                    mail.status.toUpperCase().contains(filter) ||
                    mail.signature.toUpperCase().contains(filter) ||
                    mail.packageid.toUpperCase().contains(filter) ||
                    mail.id.toUpperCase().contains(filter)
                : true) &&
            ((office != null ? mail.office.toUpperCase() == office.toUpperCase() : true) &&
                (status != null ? mail.status.toUpperCase() == status : true) &&
                (startDate != null
                    ? startDate.isBefore(DateTime.fromMillisecondsSinceEpoch(
                            mail.dateTime.millisecondsSinceEpoch)) &&
                        endDate.isAfter(DateTime.fromMillisecondsSinceEpoch(
                            mail.dateTime.millisecondsSinceEpoch))
                    : true))))
        .toList();

    return _filteredList;
  }

  /// Get the recent mails list.
  List<Mail> _getRecentList(List<Mail> listMail) {
    final _date = new DateTime.now();
    final _startDate = new DateTime(_date.year, _date.month, _date.day - 4);
    final _endDate = new DateTime(_date.year, _date.month, _date.day)
        .add(Duration(hours: 23))
        .add(Duration(minutes: 59))
        .add(Duration(seconds: 59));

    List<Mail> _filteredList = listMail
        .where((mail) => (_startDate.isBefore(
                DateTime.fromMillisecondsSinceEpoch(
                    mail.dateTime.millisecondsSinceEpoch)) &&
            _endDate.isAfter(DateTime.fromMillisecondsSinceEpoch(
                mail.dateTime.millisecondsSinceEpoch))))
        .toList();

    return _filteredList;
  }
}
