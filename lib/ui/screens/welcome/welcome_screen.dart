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
        body: Stack(children: <Widget>[
          //Welcome information.
          Align(alignment: Alignment.center, child: _welcomeInfo(context)),
          //Action buttons.
          Align(
              alignment: Alignment.bottomCenter, child: _actionButtons(context))
        ]));
  }

  /// Returns the welcome messages.
  Widget _welcomeInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: screenAwareHeight(150, context)),
        //Welcome text.
        _welcomeText(context),
        //User image.
        _userImage(context),
        SizedBox(height: screenAwareHeight(40, context)),
        //Advantage text.
        _advantageText(context),
      ],
    );
  }

  /// Return the welcome text.
  Widget _welcomeText(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 0, 16, 0),
      child: Text(
        "App de Control de Acceso para Visitantes",
        textAlign: TextAlign.center,
        style: _theme.textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Returns the image of the welcome user.
  Widget _userImage(BuildContext context) {
    return Image.asset(
      "assets/welcome_image.png",
      width: screenAwareWidth(309, context),
      fit: BoxFit.fill,
    );
  }

  /// Return the advantage text of the aplication.
  Widget _advantageText(BuildContext context) {
    return Text(
      "Seguro, Confiable y no más colas",
      style: _theme.textTheme.subtitle1.copyWith(fontStyle: FontStyle.italic),
    );
  }

  /// Return the action buttons.
  Widget _actionButtons(context) {
    return Container(
      padding: EdgeInsets.all(screenAwareWidth(24, context)),
      color: Colors.transparent,
      child: _welcomeButton(context),
    );
  }

  /// Return the register button.
  Widget _welcomeButton(BuildContext context) {
    return MainButton(
      isLoading: false,
      child: Text(
        "Iniciar",
        style: _theme.textTheme.button.copyWith(color: _theme.backgroundColor),
      ),
      enabled: true,
      onTap: () {
        navigateTo(context, LoginScreen());
      },
      height: screenAwareHeight(48, context),
      enabledColor: _theme.buttonColor,
    );
  }
}
