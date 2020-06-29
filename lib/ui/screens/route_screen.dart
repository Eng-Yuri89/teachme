import 'package:flutter/material.dart';
import 'package:teachme/models/profile.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/services/auth_service.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/screens/landing_screen.dart';
import 'package:teachme/ui/screens/welcome/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teachme/ui/screens/welcome/welcome_screen.dart';

import 'home/loading_screen.dart';

/// RouterScreen
///
/// This screen will evaluate the actual
/// user session, if the user is not active
/// the WelcomeScreen will be returned, else,
/// HomeScreen
class RouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    final DatabaseService db = Provider.of<DatabaseService>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (_, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;

          if (user == null) {
            return OnBoardingScreen();
          }

          return MultiProvider(
            providers: [
              // Make user stream available
              Provider<User>.value(value: user),
              // See implementation details in next sections
              StreamProvider<Profile>.value(
                value: db.streamProfile(user.uid),
              ),
            ],
            child: LandingScreen(),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }

  /// Validat if is first run for the app
  /// in the current device.
  Future<bool> _validateRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirst = prefs.getBool("first-run") ?? false;

    return isFirst;
  }
}
