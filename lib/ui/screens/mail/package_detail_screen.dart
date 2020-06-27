import 'package:flutter/material.dart';
import 'package:teachme/models/action_package.dart';
import 'package:teachme/models/mail.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/widgets/input_decoration.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/ui/widgets/page_header.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

/// Package detail screen.
///
/// Returns the detail page of the selected
/// package and the actions to take.
class PackageDetailScreen extends StatefulWidget {
  // Package selected.
  final Package package;
  // Hero animation unique id.
  final String uniqueId;

  PackageDetailScreen({@required this.package, @required this.uniqueId});

  @override
  _PackageDetailScreenState createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  // Action selected.
  int _action = 0;
  // Actions map.
  Map<int, String> _actionMap = {};
  // Other text field controller.
  TextEditingController _otherController = new TextEditingController();
  // Scaffold key
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Loading indicator
  bool _isLoading = false;

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
              // Package image.
              _packageImage(context),
              _packageInformation(context),
              widget.package.action != "No Actions"
                  ? _packageAction(context)
                  : _actionPackageDetail(context),
              SizedBox(height: screenAwareHeight(50, context))
            ],
          ),
        ),
      ),
    );
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
        title: "Package Detail",
      ),
    );
  }

  /// Returns the package image.
  Widget _packageImage(BuildContext context) {
    return Hero(
      tag: widget.uniqueId,
      child: FadeInImage(
        width: double.infinity,
        height: screenAwareHeight(230, context),
        fit: BoxFit.fitWidth,
        placeholder: AssetImage("assets/load.gif"),
        image: NetworkImage(
          widget.package.imageUrl ??
              "https://media.graytvinc.com/images/690*388/Holiday+shipping+12+12.JPG",
        ),
      ),
    );
  }

  /// Returns the package information.
  Widget _packageInformation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Package type text.
          Text(
            widget.package.type.toUpperCase(),
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(12, context),
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(7, context)),
          // Package condition.
          RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                  text:
                      "This package will not be in your mail slot or you may be required to sign for it: ",
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                new TextSpan(
                  text: widget.package.storagecost ? "SI" : "NO",
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: screenAwareWidth(12, context),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Returns the drop down list
  /// for the actions.
  Widget _actionDropDownList(BuildContext context) {
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Action",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(10, context)),
          // Drop down list actions.
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenAwareWidth(10, context),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(127, 128, 132, 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder<Map<int, String>>(
              stream: Provider.of<DatabaseService>(context).getActionPackage(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<int, String>> snapshot) {
                if (!snapshot.hasData) {
                  return _emptyList;
                } else {
                  _actionMap = snapshot.data;

                  return DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: Color(0xff000000)),
                      value: _action,
                      onChanged: (value) {
                        _action = value;

                        setState(() {});
                      },
                      items: Map.castFrom(snapshot.data)
                          .entries
                          .map(
                            (opt) => DropdownMenuItem(
                              child: Text(
                                opt.key > 0
                                    ? "${opt.key}. ${opt.value}"
                                    : opt.value,
                                style: TextStyle(
                                  color: Color(0x7f060110),
                                  fontSize: screenAwareWidth(12, context),
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              value: opt.key,
                            ),
                          )
                          .toList(),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  /// Returns action drop down, save button
  /// and other text field.
  Widget _actionPackageDetail(BuildContext context) {
    return Column(
      children: <Widget>[
        // Action drop down list
        _actionDropDownList(context),
        // Other text field.
        _action == 5 ? _otherTextField(context) : Container(),
        SizedBox(height: screenAwareHeight(57, context)),
        // Save button.
        _saveButton(context)
      ],
    );
  }

  /// Returns the drop down items
  List<DropdownMenuItem> _actionItems(
      BuildContext context, Map<int, String> list) {
    final _listItems = new List<DropdownMenuItem>();

    list.forEach(
      (int index, String value) {
        final _option = DropdownMenuItem(
          child: Text(
            index > 0 ? "$index. $value" : value,
            style: TextStyle(
              color: Color(0x7f060110),
              fontSize: screenAwareWidth(12, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          value: index,
        );

        _listItems.add(_option);
      },
    );

    return _listItems;
  }

  /// Returns the action take to the package.
  Widget _packageAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Package action text.
          Text(
            "ACTION",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(12, context),
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(7, context)),
          // Package condition.
          Text(
            widget.package.action,
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(12, context),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          )
        ],
      ),
    );
  }

  /// Retunrs the other action text field.
  Widget _otherTextField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: screenAwareHeight(15, context)),
          Text("Other",
              style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: screenAwareWidth(14, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal)),
          SizedBox(height: screenAwareHeight(10, context)),
          // Start date picker.
          Container(
            child: TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              cursorColor: Theme.of(context).primaryColor,
              controller: _otherController,
              style: TextStyle(
                color: Color(0xff403c47),
                fontSize: screenAwareWidth(14, context),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
              autofocus: false,
              decoration: inputDecoration(context: context),
            ),
          )
        ],
      ),
    );
  }

  /// Returns the save button.
  Widget _saveButton(BuildContext context) {
    return MainButton(
      isLoading: _isLoading,
      enabledColor: Theme.of(context).primaryColor,
      child: Text(
        "SAVE",
        style: TextStyle(
          color: Color(0xfffefefe),
          fontSize: screenAwareWidth(16, context),
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
      ),
      enabled: true,
      width: screenAwareWidth(282, context),
      height: screenAwareHeight(50, context),
      onTap: () {
        _updatePackageAction(context);
      },
    );
  }

  /// Update package mail action.
  void _updatePackageAction(BuildContext context) async {
    bool _notify = false;
    String _message = "";
    bool _isOther = false;

    //If action is empty
    if (_action == 0) {
      _message = "Select an action to save.";
      _notify = true;
    } else if (_action == 5) {
      if (_otherController.text == "") {
        _message = "Enter an action to save.";
        _notify = true;
      }
    }

    if (_notify) {
      final _snack = new SnackBar(
          content: Text(_message,
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: screenAwareWidth(12, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal)));

      _scaffoldKey.currentState.showSnackBar(_snack);
    } else {
      _isLoading = true;

      setState(() {});

      final _map = <String, dynamic>{
        "action": _isOther
            ? "${_actionMap[_action]} / ${_otherController.text}"
            : "${_actionMap[_action]}",
        "storagecost": true
      };

      // Update package in db.
      await Provider.of<DatabaseService>(context, listen: false)
          .updateCollection("packages", _map, widget.package.id);

      _isLoading = false;

      setState(() {});

      Navigator.of(context).pop();
    }
  }
}
