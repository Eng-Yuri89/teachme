import 'package:flutter/material.dart';
import 'package:teachme/utils/size.dart';

/// Declaration of the decoration that all
/// the inputs of the application will have.
InputDecoration inputDecoration({BuildContext context}) {
  return InputDecoration(
    filled: true,
    contentPadding: EdgeInsets.fromLTRB(
      screenAwareWidth(10, context),
      screenAwareHeight(10, context),
      screenAwareWidth(10, context),
      screenAwareHeight(10, context),
    ),
    fillColor: Color.fromRGBO(127, 128, 132, 0.1),
    focusedErrorBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Colors.red),
    ),
    disabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Color(0x19ed8332)),
    ),
    enabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    errorBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
    ),
  );
}
