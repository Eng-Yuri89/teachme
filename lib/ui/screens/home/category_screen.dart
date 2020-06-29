import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teachme/models/category.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/widgets/category_card.dart';
import 'package:teachme/utils/size.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static ThemeData _theme;
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
          horizontal: screenAwareWidth(24, context),
          vertical: screenAwareHeight(20, context)),
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
                  hintText: "Search a category",
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
      child: StreamBuilder<List<Category>>(
        stream: Provider.of<DatabaseService>(context).getCategory(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return GridView.count(
                padding: EdgeInsets.symmetric(
                    horizontal: screenAwareWidth(14, context)),
                mainAxisSpacing: 12.0,
                crossAxisCount: 2,
                children: snapshot.data
                    .map(
                      (category) => CategoryCard(
                        theme: _theme,
                        categoryName: category.name,
                      ),
                    )
                    .toList(),
              );
            } else {
              return Center(
                child: Text(
                  "No data.",
                  style: _theme.textTheme.bodyText2.copyWith(
                    color: _theme.accentColor.withOpacity(0.8),
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.4),
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            );
          }
        },
      ),
    );
  }
}
