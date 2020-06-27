import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teachme/constants/strings.dart';
import 'package:teachme/models/profile.dart';
import 'package:teachme/services/auth_service.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/ui/widgets/platform_alert_dialog.dart';
import 'package:teachme/ui/widgets/platform_exception_alert_dialog.dart';
import 'package:teachme/ui/widgets/screen_header.dart';
import 'package:teachme/ui/widgets/setting_option.dart';
import 'package:teachme/ui/widgets/stadistics_profile_card.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      ScreenHeader(title: 'Profile'),
      SizedBox(height: screenAwareHeight(30, context)),
      _headerProfile(context),
      SizedBox(height: screenAwareHeight(70, context)),
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
        child: Column(children: [
          SettingOption(
            optionName: 'Terms of Service',
            imageIcon: 'assets/settings/tos_icon.svg',
          ),
          SettingOption(
            optionName: 'Privacy Policy',
            imageIcon: 'assets/settings/book-open.svg',
          ),
        ]),
      ),
      SizedBox(
        height: screenAwareHeight(100, context),
      ),
      // Sign Out Session Option
      _signOutButton(context),
      SizedBox(
        height: screenAwareHeight(20, context),
      ),
    ]));
  }

  Widget _headerProfile(context) {
    return Column(
      children: [
        CircleAvatar(
            radius: screenAwareHeight(50, context),
            backgroundImage: NetworkImage(
                "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50")),
        SizedBox(
          height: screenAwareHeight(20, context),
        ),
        // Display name for the user
        new Text(
            "${Provider.of<Profile>(context).firstName} ${Provider.of<Profile>(context).lastName}",
            style: TextStyle(
              color: Theme.of(context).buttonColor,
              fontSize: screenAwareWidth(20, context),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            )),
        SizedBox(
          height: screenAwareHeight(5, context),
        ),
        // This is the company information.
        new Text("H&H Printers S.A.",
            style: TextStyle(
              color: Color(0xff060110),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            )),
      ],
    );
  }

  /// Login button action.
  Widget _signOutButton(BuildContext context) {
    return MainButton(
      isLoading: false,
      enabledColor: Theme.of(context).primaryColor,
      onTap: () {
        _confirmSignOut(context);
      },
      child: Text(
        "SIGN OUT",
        style: TextStyle(
          color: Color(0xfffefefe),
          fontSize: screenAwareWidth(16, context),
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
      ),
      enabled: true,
      width: screenAwareWidth(152, context),
      height: screenAwareHeight(32, context),
    );
  }

  /// This functions will show a alert message [PlatformAlertDialog]
  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  /// Internal method to close actual session
  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = Provider.of<AuthService>(context, listen: false);

      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }
}
