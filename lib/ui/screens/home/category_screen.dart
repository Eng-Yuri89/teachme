import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static ThemeData _theme;

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
    _theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _filterInput(context),
            _grid(context),
          ],
        ),
      ),
    );
  }

  Widget _filterInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(30, context),
          vertical: screenAwareHeight(30, context)),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(15, context)),
        height: screenAwareHeight(50, context),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(26, 27, 29, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Search icon
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
                      screenAwareHeight(15, context),
                      screenAwareWidth(10, context),
                      screenAwareHeight(0, context)),
                  border: InputBorder.none,
                  hintText: "Search a Teacher",
                  hintStyle: TextStyle(
                    color: _theme.backgroundColor.withOpacity(0.50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
        crossAxisCount: 2,
        children: _categories
            .map(
              (c) => Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(26, 27, 29, 1),
                  borderRadius: BorderRadius.circular(
                    screenAwareWidth(5, context),
                  ),
                ),
                margin: new EdgeInsets.symmetric(
                  horizontal: screenAwareHeight(10, context),
                  vertical: screenAwareWidth(10, context),
                ),
                width: 50,
                height: 50,
                child: Center(
                  child: Text(
                    "$c",
                    style: _theme.textTheme.subtitle2.copyWith(
                      color: _theme.backgroundColor,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
