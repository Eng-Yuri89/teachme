import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teachme/constants/strings.dart';
import 'package:teachme/ui/widgets/platform_exception_alert_dialog.dart';

/// Validator for email in Forms
String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value) && value.isNotEmpty)
    return 'Enter Valid Email';
  else if (value.isEmpty)
    return 'This field is required';
  else
    return null;
}

/// Function to launch an animated navigation to the
/// next screen.
void navigateTo(BuildContext context, Widget nextPage) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return OpenContainer(
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return nextPage;
        },
        tappable: false,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return nextPage;
        },
      );
    },
  ));
}

/// Function to launch an animated navigation to the
/// next screen.
void navigateToPushReplace(BuildContext context, Widget nextPage) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return OpenContainer(
          transitionType: ContainerTransitionType.fade,
          openBuilder: (BuildContext context, VoidCallback _) {
            return nextPage;
          },
          tappable: false,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return nextPage;
          },
        );
      },
    ),
  );
}

/// ShowError Method
///
/// This is the method to catch and
/// show a error message
Future<void> showSignInError(
    BuildContext context, PlatformException exception) async {
  await PlatformExceptionAlertDialog(
    title: Strings.signInFailed,
    exception: exception,
  ).show(context);
}
