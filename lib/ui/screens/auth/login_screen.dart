import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:teachme/models/profile.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/services/auth_service.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/services/signin_manager.dart';
import 'package:teachme/ui/screens/landing_screen.dart';
import 'package:teachme/ui/widgets/input_decoration.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final AuthService auth = Provider.of<AuthService>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            Provider<SignInManager>(
          create: (_) => SignInManager(
              auth: auth, isLoading: isLoading, db: databaseService),
          child: Consumer<SignInManager>(
            builder: (_, SignInManager manager, __) => LoginScreenBody._(
              isLoading: isLoading.value,
              manager: manager,
            ),
          ),
        ),
      ),
    );
  }
}

/// Login screen.
///
/// Page to log in with credentials or with a google account.
class LoginScreenBody extends StatefulWidget {
  /// Constructor
  LoginScreenBody._({
    Key key,
    @required this.isLoading,
    @required this.manager,
  }) : super(key: key);

  /// All the business logics
  /// is in charge of this object
  final SignInManager manager;

  /// When the cient does a call
  /// to the manager this loading variable
  /// will allow the UI to manage this status
  final bool isLoading;

  @override
  _LoginScreenBodyState createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  // Theme data.
  ThemeData _theme;

  ///
  /// This is the method to authenticate the user with
  /// Google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final user = await widget.manager.signInWithGoogle();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              // Make user stream available
              Provider<User>.value(value: user),
              // See implementation details in next sections
              StreamProvider<Profile>.value(
                value: widget.manager.db.streamProfile(user.uid),
              ),
            ],
            child: LandingScreen(),
          ),
        ),
      );
    } on PlatformException catch (e) {
      showSignInError(context, e);
    }
  }

  ///
  /// This is the method to authenticate the user with
  /// Google
  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final user = await widget.manager.signInWithFacebook();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              // Make user stream available
              Provider<User>.value(value: user),
              // See implementation details in next sections
              StreamProvider<Profile>.value(
                value: widget.manager.db.streamProfile(user.uid),
              ),
            ],
            child: LandingScreen(),
          ),
        ),
      );
    } on PlatformException catch (e) {
      showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[_pageHeader(context), _buttons(context)],
          ),
        ),
      ),
    );
  }

  ///Returns the icon with the login information
  Widget _pageHeader(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: screenAwareHeight(60, context),
        ),
        Image.asset(
          "assets/welcome/login_icon.png",
          fit: BoxFit.fill,
          width: screenAwareWidth(44, context),
        ),
        SizedBox(
          height: screenAwareHeight(40, context),
        ),
        Text(
          "Create an Account to start learning",
          style: _theme.textTheme.subtitle2.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
        SizedBox(
          height: screenAwareHeight(30, context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenAwareWidth(20, context),
          ),
          child: Text(
            "When you create a new account you accept\n the Terms of Use of TeachMe",
            style: _theme.textTheme.subtitle2.copyWith(
              color: const Color.fromRGBO(249, 249, 255, 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: screenAwareHeight(60, context),
        ),
      ],
    );
  }

  ///Login buttons are created
  Widget _buttons(BuildContext context) {
    return Column(
      children: <Widget>[
        _facebookButton(context),
        SizedBox(
          height: screenAwareHeight(20, context),
        ),
        Text(
          "or",
          style: _theme.textTheme.subtitle1.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
        SizedBox(
          height: screenAwareHeight(20, context),
        ),
        _googleButton(context),
      ],
    );
  }

  ///Returns the button to log in with Facebook
  Widget _facebookButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
      child: MainButton(
        enabledColor: const Color.fromRGBO(90, 126, 255, 1),
        isLoading: false,
        borderRadius: 5,
        onTap: () {
          _signInWithFacebook(context);
        },
        height: screenAwareHeight(50, context),
        enabled: true,
        child: Text(
          "Continue with Facebook",
          style: _theme.textTheme.button.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
      ),
    );
  }

  ///Returns the button to log in with Google
  Widget _googleButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
      child: MainButton(
        enabledColor: const Color.fromRGBO(255, 90, 90, 1),
        isLoading: false,
        borderRadius: 5,
        onTap: () {
          _signInWithGoogle(context);
        },
        height: screenAwareHeight(50, context),
        enabled: true,
        child: Text(
          "Continue with Google",
          style: _theme.textTheme.button.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
      ),
    );
  }
}
