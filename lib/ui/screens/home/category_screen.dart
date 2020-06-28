import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachme/ui/widgets/sufix_clear_icon.dart';
import 'package:teachme/utils/size.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Filter input controller
  TextEditingController _filterController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: screenAwareHeight(32, context)),
        _filterInput(context)
      ],
    );
  }

  /// Return the filter widget.
  Widget _filterInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(24, context)),
      child: Container(
        padding: EdgeInsets.only(left: screenAwareWidth(15, context)),
        height: screenAwareHeight(50, context),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1B1D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Search icon.
            SvgPicture.asset(
              "assets/landing/search.svg",
              fit: BoxFit.fill,
              width: screenAwareHeight(25, context),
              color: Theme.of(context).backgroundColor.withOpacity(.5),
            ),
            SizedBox(width: screenAwareWidth(10, context)),
            // Filter text or filters selected.
            Expanded(
              child: TextFormField(
                controller: _filterController,
                autofocus: false,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: Theme.of(context).backgroundColor),
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  suffixIcon: SuffixClearButton(
                    controller: _filterController,
                  ),
                  border: InputBorder.none,
                  hintText: "Search teacher by name or keyword",
                  hintStyle: Theme.of(context).textTheme.subtitle2.copyWith(
                      color:
                          Theme.of(context).backgroundColor.withOpacity(0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
