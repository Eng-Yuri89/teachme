import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teachme/models/issue_message.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/models/voclients.dart';
import 'package:teachme/services/auth_service.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/services/forms/form_manager.dart';
import 'package:teachme/ui/widgets/input_decoration.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/ui/widgets/page_header.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:teachme/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Send message header manager with
/// ValueNorifiers for the update UI.
class SendMessageScreenHeader extends StatelessWidget {
  const SendMessageScreenHeader({
    Key key,
    this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, child) =>
            Provider<FormManager>(
          create: (_) => FormManager(
              auth: auth, isLoading: isLoading, db: databaseService),
          child: Consumer<FormManager>(
            builder: (_, FormManager manager, __) => SendMessageScreenBody._(
                isLoading: isLoading.value, manager: manager, user: user),
          ),
        ),
      ),
    );
  }
}

/// Send message screen
///
/// Returns the page for the send message.
class SendMessageScreenBody extends StatefulWidget {
  //final Event event;
  SendMessageScreenBody._(
      {Key key,
      @required this.isLoading,
      @required this.manager,
      @required this.user})
      : super(key: key);

  /// All the business logics
  /// is in charge of this object
  final FormManager manager;

  /// When the cient does a call
  /// to the manager this loading variable
  /// will allow the UI to manage this status
  final bool isLoading;

  /// User Session
  final User user;

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreenBody> {
  // Office list.
  List<String> _officeList = [
    "",
    "H&H Solutions",
    "Cansas Office",
    "Work Office"
  ];
  // Office selected.
  String _office;
  // Issue selected.
  String _issue;
  // Message text controller.
  TextEditingController _messageController = new TextEditingController();

  // Form key.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Page header.
          _pageHeader(context),
          SizedBox(height: screenAwareHeight(10, context)),
          // Office dropdownlist.
          _officeDropDownList(context),
          SizedBox(height: screenAwareHeight(10, context)),
          // Issue or consult dropdownlist.
          _issueConsultDropDownList(context),
          // Message text area.
          _messageTextArea(context),
          SizedBox(height: screenAwareHeight(50, context)),
          // Send button.
          _sendButton(context)
        ]),
      ),
    )));
  }

  /// Returns the page header.
  Widget _pageHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(30, context),
        vertical: screenAwareWidth(30, context),
      ),
      child: PageHeader(
        color: Theme.of(context).buttonColor,
        fontWeight: FontWeight.bold,
        arrowSize: screenAwareWidth(25, context),
        fontSize: screenAwareWidth(18, context),
        title: "Send Message",
      ),
    );
  }

  /// Returns the Office dropdownlist.
  Widget _officeDropDownList(BuildContext context) {
    final _emptyList = DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xff000000)),
        value: "",
        onChanged: (value) {},
        items: [
          DropdownMenuItem(child: Text(""), value: ""),
        ],
      ),
    );

    return FormField<String>(
      validator: (value) {
        if (value == null) {
          return "This field is required";
        }

        return null;
      },
      builder: (FormFieldState<String> state) {
        return Container(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Office",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: screenAwareWidth(14, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: screenAwareHeight(10, context)),
              // Drop down list office.
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(10, context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StreamBuilder<List<VOClients>>(
                  stream: Provider.of<DatabaseService>(context)
                      .streamVOClients(widget.user.email),
                  builder: (BuildContext _context,
                      AsyncSnapshot<List<VOClients>> officeSnapshot) {
                    if (!officeSnapshot.hasData) {
                      return _emptyList;
                    } else {
                      return StreamBuilder<Map<String, String>>(
                        stream: Provider.of<DatabaseService>(context)
                            .getOfficeFilter(officeSnapshot.data),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, String>> filterSnapshot) {
                          if (!filterSnapshot.hasData) {
                            return _emptyList;
                          } else {
                            if (filterSnapshot.data.length > 0) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      color: Color(0xff000000)),
                                  value: _office ?? filterSnapshot.data[0],
                                  onChanged: (value) {
                                    _office = value;
                                    setState(() {});
                                  },
                                  items:
                                      /* filterSnapshot.data
                                      .map(
                                        (office) => DropdownMenuItem(
                                          child: Text(
                                            office,
                                            style: TextStyle(
                                              color: Color(0x7f060110),
                                              fontSize:
                                                  screenAwareWidth(12, context),
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          value: office,
                                        ),
                                      )
                                      .toList() */
                                      filterSnapshot.data.entries
                                          .map(
                                            (office) => DropdownMenuItem(
                                              child: Text(
                                                office.key,
                                                style: TextStyle(
                                                  color: Color(0x7f060110),
                                                  fontSize: screenAwareWidth(
                                                      12, context),
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                              value: office.value,
                                            ),
                                          )
                                          .toList(),
                                ),
                              );
                            } else {
                              return _emptyList;
                            }
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: screenAwareHeight(5, context)),
              // Requiered text validator
              state.errorText != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: screenAwareWidth(10, context),
                        top: screenAwareHeight(5, context),
                      ),
                      child: Text(
                        state.errorText,
                        style: TextStyle(
                          color: Color.fromRGBO(209, 47, 47, 1),
                          fontSize: screenAwareWidth(10.5, context),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        );
      },
    );
  }

  /// Returns the issue or consult
  /// Dropdowlist
  Widget _issueConsultDropDownList(BuildContext context) {
    final _emptyList = DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xff000000)),
        value: "",
        onChanged: (value) {},
        items: [
          DropdownMenuItem(child: Text(""), value: ""),
        ],
      ),
    );

    return FormField<String>(
      validator: (value) {
        if (value == null) {
          return "This field is required";
        }

        return null;
      },
      builder: (FormFieldState<String> state) {
        return Container(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Choose your Issue or Consult",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: screenAwareWidth(14, context),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: screenAwareHeight(10, context)),
              // Drop down list issues.
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenAwareWidth(10, context)),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: state.errorText != null
                        ? Color.fromRGBO(241, 67, 54, 1)
                        : Colors.transparent,
                  ),
                ),
                child: StreamBuilder<List<IssueMessage>>(
                  stream:
                      Provider.of<DatabaseService>(context).getIssueMessage(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<IssueMessage>> issueSnapshot) {
                    if (!issueSnapshot.hasData) {
                      return _emptyList;
                    } else {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xff000000),
                          ),
                          value: _issue ?? issueSnapshot.data[0].issue,
                          onChanged: (value) {
                            _issue = value;
                            state.didChange(value);

                            setState(() {});
                          },
                          items: issueSnapshot.data
                              .map(
                                (issue) => DropdownMenuItem(
                                  child: Text(
                                    issue.issue,
                                    style: TextStyle(
                                      color: Color(0x7f060110),
                                      fontSize: screenAwareWidth(12, context),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  value: issue.issue,
                                ),
                              )
                              .toList(),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: screenAwareHeight(5, context)),
              // Requiered text validator
              state.errorText != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: screenAwareWidth(10, context),
                        top: screenAwareHeight(5, context),
                      ),
                      child: Text(
                        state.errorText,
                        style: TextStyle(
                          color: Color.fromRGBO(209, 47, 47, 1),
                          fontSize: screenAwareWidth(10.5, context),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        );
      },
    );
  }

  /// Returns the messate text area.
  Widget _messageTextArea(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenAwareHeight(15, context)),
              Text("Message",
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: screenAwareWidth(14, context),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal)),
              SizedBox(height: screenAwareHeight(10, context)),
              // Start date picker.
              Container(
                  child: TextFormField(
                      maxLines: 7,
                      keyboardType: TextInputType.multiline,
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _messageController,
                      style: TextStyle(
                        color: Color(0xff403c47),
                        fontSize: screenAwareWidth(14, context),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'This field is required';
                        return null;
                      },
                      autofocus: false,
                      decoration: inputDecoration(context: context)))
            ]));
  }

  /// Returns the send button.
  Widget _sendButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Center(
        child: MainButton(
            isLoading: widget.isLoading,
            enabledColor: Theme.of(context).primaryColor,
            child: Text("SEND",
                style: TextStyle(
                  color: Color(0xfffefefe),
                  fontSize: screenAwareWidth(16, context),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
            enabled: true,
            width: screenAwareWidth(282, context),
            height: screenAwareHeight(50, context),
            onTap: () async {
              // Call the Manager to save the message
              if (_formKey.currentState.validate()) {
                try {
                  final _message = new Message(
                      dateTime: Timestamp.fromDate(DateTime.now()),
                      officeId: _office,
                      issue: _issue,
                      message: _messageController.text,
                      senderId: widget.user.uid);

                  await widget.manager.createMessage(_message);

                  Navigator.of(context).pop(true);
                } on PlatformException catch (e) {
                  print("error send message.");
                }
              }
            }),
      ),
    );
  }
}
