import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachme/ui/screens/auth/login_screen.dart';
import 'package:teachme/ui/screens/auth/register_screen.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';

/// Welcome screen.
///
/// Welcome page where you select whether
/// you want to log in or register.
class WelcomeScreen extends StatelessWidget {
  //Application theme
  static ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.scaffoldBackgroundColor,
      body: Container()
    );
  }
}
