import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// These method will manage
/// our light theme automatically
///
/// It is important to define
/// main colors and styles here
ThemeData buildLightTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith();
  }

  // Override a default light theme.
  final ThemeData base = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      headline4: base.textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
      headline6: base.textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
      button: base.textTheme.button.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.125,
        fontSize: 14.0,
      ),
    ),
    primaryColor: const Color.fromRGBO(103, 90, 255, 1),
    accentColor: const Color.fromRGBO(249, 249, 255, 1),
    scaffoldBackgroundColor: const Color(0x020202),
    backgroundColor: const Color.fromRGBO(249, 249, 255, 1),
    appBarTheme: AppBarTheme(color: Color(0xFFFFFFFF)),
    iconTheme: IconThemeData(color: Color(0xFF1B1B1D)),
    //Check box and toogle colors.
    unselectedWidgetColor: Color.fromRGBO(127, 128, 132, 0),
    //BottomNavigationBar color.
    bottomAppBarColor: Color(0xfffefdff),
    buttonColor: const Color(0xFF1B1B1D),
    //DropdownListButton color.
    canvasColor: Color.fromRGBO(238, 238, 240, 1),
  );
}

/// These method will manage
/// our dark theme automatically
///
/// It is important to define
/// main colors and styles here
ThemeData buildDarkTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith();
  }

  // Override a default light theme.
  final ThemeData base = ThemeData.dark();
  // And apply changes on it:
  return base.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColor: const Color(0xff7332ed),
    primaryColorLight: const Color(0xFF8FBF98),
    primaryColorDark: const Color(0xFF626E73),
    scaffoldBackgroundColor: const Color(0xFF18191A),
    buttonColor: const Color(0xFF060110),
  );
}
