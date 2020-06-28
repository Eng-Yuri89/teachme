import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> _categories = [
    "Physical Training",
    "Photography",
    "Programming",
    "Finances",
    "Sciences",
    "Design, Photography"
  ];

  TextEditingController _filterController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[_filterInput(context)],
        ),
      ),
    );
  }

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
            Image.asset("assets/landing/search_active.png",
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
          ],
        ),
      ),
    );
  }
}
