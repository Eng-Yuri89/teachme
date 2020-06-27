import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teachme/constants/strings.dart';
import 'package:teachme/services/auth_service.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/services/signin_manager.dart';
import 'package:teachme/ui/widgets/input_decoration.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/ui/widgets/page_header.dart';
import 'package:teachme/ui/widgets/platform_exception_alert_dialog.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

/// Register screen.
///
/// Page to register in the application with mail and personal data.
class RegisterScreen extends StatelessWidget {
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
            builder: (_, SignInManager manager, __) => RegisterScreenBody._(
              isLoading: isLoading.value,
              manager: manager,
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreenBody extends StatefulWidget {
  /// Constructor
  RegisterScreenBody._({
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
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreenBody> {
  /// Theme of application.
  static ThemeData _theme;

  /// Checkbox status.
  bool _accept = false;

  /// Form Key identifier
  final _signUpFormKey = GlobalKey<FormState>();

  //// In charge to every field on
  ///  the actual signup form
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();

  /// When the user try to signup
  /// if something is wrong a exception
  /// will be launched
  Future<void> _showSignUpError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.registrationFailed,
      exception: exception,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Page header.
                _pageHeader(context),
                //First name input.
                _firstNameInput(context),
                SizedBox(height: screenAwareHeight(10, context)),
                //Last name input.
                _lastNameInput(context),
                SizedBox(height: screenAwareHeight(10, context)),
                //Email input.
                _emailInput(context),
                SizedBox(height: screenAwareHeight(10, context)),
                //Password input.
                _passwordInput(context),
                SizedBox(height: screenAwareHeight(10, context)),
                //Confirm password input.
                _confirmPasswordInput(context),
                SizedBox(height: screenAwareHeight(35, context)),
                //Checkbox accept terms and conditions.
                _checkBoxTerms(context),
                SizedBox(height: screenAwareHeight(56, context)),
                //Register button.
                _registerButton(context),
                SizedBox(height: screenAwareHeight(30, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Return the page header with arrow to go
  /// back and the title page.
  Widget _pageHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: screenAwareHeight(25, context),
        bottom: screenAwareHeight(37, context),
      ),
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: PageHeader(
        arrowSize: screenAwareWidth(22, context),
        fontSize: screenAwareWidth(14, context),
        title: "Create an Account",
      ),
    );
  }

  /// Return input for the first name field.
  Widget _firstNameInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "First Name",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(10, context)),
          // Full name input.
          TextFormField(
            controller: _firstName,
            cursorColor: _theme.primaryColor,
            style: TextStyle(
              color: Color(0xff403c47),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
            autofocus: false,
            decoration: inputDecoration(context: context),
            validator: (value) {
              if (value == "") return "This field is required.";
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Return input for the full name field.
  Widget _lastNameInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Last Name",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(10, context)),
          // Full name input.
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _lastName,
            cursorColor: _theme.primaryColor,
            style: TextStyle(
              color: Color(0xff403c47),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
            autofocus: false,
            decoration: inputDecoration(context: context),
            validator: (value) {
              if (value == "") return "This field is required.";

              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Return input for the email field.
  Widget _emailInput(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Email",
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: screenAwareWidth(14, context),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal)),
              SizedBox(height: screenAwareHeight(10, context)),
              // Email input.
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                cursorColor: _theme.primaryColor,
                style: TextStyle(
                  color: Color(0xff403c47),
                  fontSize: screenAwareWidth(14, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
                autofocus: false,
                decoration: inputDecoration(context: context),
                validator: (value) {
                  if (value == "") return "This field is required.";

                  return null;
                },
              )
            ]));
  }

  /// Return input for the password field.
  Widget _passwordInput(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Password",
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: screenAwareWidth(14, context),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal)),
              SizedBox(height: screenAwareHeight(10, context)),
              // Password input.
              TextFormField(
                controller: _password,
                obscureText: true,
                cursorColor: _theme.primaryColor,
                style: TextStyle(
                  color: Color(0xff403c47),
                  fontSize: screenAwareWidth(14, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
                autofocus: false,
                decoration: inputDecoration(context: context),
                validator: (value) {
                  if (value == "") return "This field is required.";

                  return null;
                },
              )
            ]));
  }

  /// Return input for the confirm password field.
  Widget _confirmPasswordInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Confirm Password",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          SizedBox(height: screenAwareHeight(10, context)),
          // Confirm password input.
          TextFormField(
            controller: _confirmPassword,
            obscureText: true,
            cursorColor: _theme.primaryColor,
            style: TextStyle(
              color: Color(0xff403c47),
              fontSize: screenAwareWidth(14, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
            autofocus: false,
            decoration: inputDecoration(context: context),
            validator: (value) {
              if (value == "") return "This field is required.";
              if (value != _password.text) return "The passwords do not match.";

              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Return the checkbox to accept the terms and conditions.
  Widget _checkBoxTerms(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(35, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Checkbox for terms.
          Transform.scale(
            scale: 1.5,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(127, 128, 132, 0.1),
              ),
              child: Checkbox(
                autofocus: false,
                checkColor: _theme.primaryColor,
                activeColor: Color.fromRGBO(127, 128, 132, 0),
                tristate: true,
                value: _accept,
                onChanged: (value) {
                  _accept = !_accept;

                  setState(() {});
                },
              ),
              width: 20,
              height: 20,
            ),
          ),
          SizedBox(width: screenAwareWidth(10, context)),
          //Checkbox description.
          Text(
            "Accept Terms and Conditions",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Color(0xff000000),
              fontSize: screenAwareWidth(12, context),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          )
        ],
      ),
    );
  }

  /// Return the register button.
  Widget _registerButton(BuildContext context) {
    return Center(
      child: MainButton(
        isLoading: false,
        enabledColor: Theme.of(context).primaryColor,
        disableColor: Theme.of(context).primaryColor,
        onTap: () async {
          // Before all the form needs to be validated
          if (_signUpFormKey.currentState.validate() && _accept) {
            try {
              await widget.manager.createUserWithEmailAndPassword(
                  _email.text, _password.text, _firstName.text, _lastName.text);
              Navigator.of(context).pop();
              //_showRegisterSuccessfully(context);
            } on PlatformException catch (e) {
              _showSignUpError(context, e);
            }
          }
        },
        child: Text(
          "SIGN UP",
          style: TextStyle(
            color: Color(0xfffefefe),
            fontSize: screenAwareWidth(16, context),
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
          ),
        ),
        enabled: _accept ? true : false,
        width: screenAwareWidth(285, context),
        height: screenAwareHeight(
          50,
          context,
        ),
      ),
    );
  }
}
