import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required ThemeData theme,
    this.categoryName,
  })  : theme = theme,
        super(key: key);

  final ThemeData theme;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 27, 29, 1),
        borderRadius: BorderRadius.circular(
          screenAwareWidth(5, context),
        ),
      ),
      margin: new EdgeInsets.only(
          top: screenAwareWidth(10, context),
          bottom: screenAwareWidth(10, context),
          left: screenAwareWidth(10, context),
          right: screenAwareWidth(10, context)),
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
      width: 50,
      height: 50,
      child: Center(
        child: Text(
          "$categoryName",
          style: theme.textTheme.subtitle2.copyWith(
            color: theme.backgroundColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
