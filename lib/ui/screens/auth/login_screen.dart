import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:teachme/services/auth_service.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/services/signin_manager.dart';
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

  // Input Controllers for
  // email and password
  TextEditingController phoneNumber = TextEditingController(text: '');

  // Confirm OTP code
  TextEditingController verificationCodeController =
      TextEditingController(text: '');

  //Form Key identifier
  final _signInFormKey = new GlobalKey<FormState>();

  /// SignIn Method
  ///
  /// This is the method to authenticate the user with
  /// Email and password
  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    if (_signInFormKey.currentState.validate()) {
      try {
        await widget.manager.verifyPhoneNumber(phoneNumber.text);
      } on PlatformException catch (e) {
        showSignInError(context, e);
      }
    }
  }

  Future<void> _validateOTPCode(BuildContext context) async {
    try {
      await widget.manager
          .signInWithPhoneNumber(verificationCodeController.text);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      bottomSheet: Text(''),
      body: SingleChildScrollView(
        child: Form(
          key: _signInFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _headerText(),
              _loginInputs(context),
              SizedBox(height: screenAwareHeight(40, context)),
              _loginActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          Text('Bienvenido a TLAR',
              style: _theme.textTheme.headline6
                  .copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: screenAwareHeight(24, context),
          ),
          Text(
            'Ingrese su número de teléfono para entrar a la aplicación.',
            textAlign: TextAlign.justify,
            style: _theme.textTheme.subtitle2,
          ),
          SizedBox(
            height: screenAwareHeight(24, context),
          ),
        ],
      ),
    );
  }

  /// Return the login inputs.
  Widget _loginInputs(BuildContext context) {
    return Column(
      children: <Widget>[
        //Email input.
        _input(context),
      ],
    );
  }

  /// Return the textField from the email.
  Widget _input(BuildContext context) {
    Widget pinCodeTextField = PinCodeTextField(
      highlightAnimation: true,
      highlightAnimationBeginColor: Colors.white,
      highlightAnimationEndColor: Theme.of(context).primaryColor,
      pinTextAnimatedSwitcherDuration: Duration(milliseconds: 500),
      wrapAlignment: WrapAlignment.center,
      autofocus: true,
      pinTextStyle: _theme.textTheme.headline6,
      controller: verificationCodeController,
      hasTextBorderColor: Theme.of(context).primaryColor,
      pinBoxBorderWidth: 0,
      pinBoxRadius: 5,
      maxLength: 6,
      pinBoxHeight: screenAwareHeight(50, context),
      pinBoxWidth: screenAwareHeight(50, context),
      onDone: null,
    );
    Widget textFormField = TextFormField(
      keyboardType: TextInputType.phone,
      cursorColor: _theme.primaryColor,
      maxLength: 8,
      maxLengthEnforced: true,
      controller: phoneNumber,
      validator: (value) {
        if (value == "") return "This field is required.";
        return null;
      },
      style: _theme.textTheme.subtitle1,
      autofocus: true,
      decoration: inputDecoration(context: context),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(24, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.isLoading ? 'Código Validación' : 'Teléfono',
              style: _theme.accentTextTheme.subtitle2),
          SizedBox(height: screenAwareHeight(10, context)),
          // Email input.
          widget.isLoading ? pinCodeTextField : textFormField
        ],
      ),
    );
  }

  /// Return the login action buttons.
  Widget _loginActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: _loginButton(context),
    );
  }

  /// Login button action.
  Widget _loginButton(BuildContext context) {
    return MainButton(
      enabledColor: _theme.buttonColor,
      isLoading: false,
      onTap: () {
        widget.isLoading
            ? _validateOTPCode(context)
            : _signInWithPhoneNumber(context);
      },
      child: Text(
        widget.isLoading ? 'Confirmar' : 'Validar',
        style: _theme.textTheme.button.copyWith(color: _theme.backgroundColor),
      ),
      enabled: true,
      height: screenAwareHeight(50, context),
    );
  }
}
