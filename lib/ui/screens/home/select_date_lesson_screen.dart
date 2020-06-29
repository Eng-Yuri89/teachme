import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:teachme/models/lesson.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/ui/widgets/fade_animation.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/ui/widgets/message_dialog.dart';
import 'package:teachme/utils/size.dart';
import 'package:jiffy/jiffy.dart';

///PurchaseCourseSelectDate
///
///On this screen you must select the date
///on which you want to receive the class.
class SelectDateLessonScreen extends StatefulWidget {
  final Teacher teacher;
  final Lesson lesson;
  final String heroKey;

  SelectDateLessonScreen({this.teacher, this.lesson, this.heroKey});

  @override
  _SelectDateLessonScreenState createState() => _SelectDateLessonScreenState();
}

class _SelectDateLessonScreenState extends State<SelectDateLessonScreen> {
  Size _size;
  ThemeData _theme;
  DateTime _date;
  int _currentButton = 0;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: _size.height * 0.60,
            width: _size.width,
            child: _pageHeader(context),
          ),
          SizedBox(height: screenAwareHeight(39, context)),
          _lessonDescription(context),
          _currentButton == 0 ? Container() : _purchaseConfirmation(context)
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Visibility(
            visible: _currentButton == 0 ? true : false,
            child: _selectDateButton(context),
          ),
          Visibility(
            visible: _currentButton == 1 ? true : false,
            child: _purchaseButton(context),
          ),
        ],
      ),
    );
  }

  ///Returns the teacher image and
  ///short information.
  Widget _pageHeader(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Hero(
          tag: widget.heroKey,
          child: FadeInImage(
            fit: BoxFit.cover,
            placeholder: AssetImage("assets/home/loading.gif"),
            image: NetworkImage(widget.teacher.photoUrl),
          ),
        ),
        Image.asset(
          'assets/teacher/gradient.png',
          fit: BoxFit.fill,
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: Container()),
            //Teacher name.
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenAwareWidth(36, context)),
              child: Text(
                widget.lesson.title,
                style: _theme.textTheme.headline4.copyWith(
                  color: _theme.accentColor,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  ///Return the lesson description.
  Widget _lessonDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(24, context)),
      width: screenAwareWidth(350, context),
      height: screenAwareHeight(50, context),
      child: AutoSizeText(
        widget.lesson.description,
        style: _theme.textTheme.subtitle1.copyWith(
          color: _theme.accentColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  ///Returns the bottom button.
  Widget _selectDateButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(20, context),
          vertical: screenAwareHeight(20, context)),
      child: FadeAnimation(
        0.7,
        MainButton(
          enabledColor: _theme.primaryColor,
          disableColor: Color.fromRGBO(116, 115, 131, 1),
          child: Text(
            "SELECT DATE",
            style: _theme.textTheme.button.copyWith(
              color: _theme.accentColor,
            ),
          ),
          enabled: true,
          height: screenAwareHeight(50, context),
          isLoading: false,
          borderRadius: screenAwareWidth(5, context),
          onTap: () {
            _cupertinoDatePicker(context);
          },
        ),
      ),
    );
  }

  ///Returns the purchase button.
  Widget _purchaseButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(20, context),
          vertical: screenAwareHeight(20, context)),
      child: FadeAnimation(
        0.7,
        MainButton(
          enabledColor: _theme.primaryColor,
          disableColor: Color.fromRGBO(116, 115, 131, 1),
          child: Text(
            "PURCHASE",
            style: _theme.textTheme.button.copyWith(
              color: _theme.accentColor,
            ),
          ),
          enabled: true,
          height: screenAwareHeight(50, context),
          isLoading: false,
          borderRadius: screenAwareWidth(5, context),
          onTap: () {
            _purchasLesson();
          },
        ),
      ),
    );
  }

  ///Purchase the selected lesson.
  void _purchasLesson() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, animation1, animation2, widget) {
          return Transform.scale(
            scale: animation1.value,
            child: Opacity(opacity: animation1.value, child: widget),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          // The place o
          return MessageDialog(
            title: 'Purchase completed',
            body:
                'Thanks for being part of TeachME, we hope you enjoy your session.',

            // Confirm to add as a OrgLeader
            onTap: () {
              //Navigator.pushReplacement(context, Landin);
            },
          );
        });
  }

  ///Cupertino date time picker.
  void _cupertinoDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime(DateTime.now().year - 2),
      maxDateTime: DateTime(DateTime.now().year + 2),
      initialDateTime: DateTime.now(),
      dateFormat: "MMMM-dd-yyyy HH:mm",
      locale: DateTimePickerLocale.en_us,
      pickerMode: DateTimePickerMode.datetime,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        itemTextStyle: _theme.textTheme.subtitle1.copyWith(
          color: _theme.accentColor,
        ),
        backgroundColor: _theme.scaffoldBackgroundColor,
        pickerHeight: screenAwareHeight(200, context),
        cancel: Text(
          "Cancel",
          style: _theme.textTheme.button.copyWith(
            color: _theme.accentColor,
          ),
        ),
        confirm: Text(
          "Confirm",
          style: _theme.textTheme.button.copyWith(
            color: _theme.accentColor,
          ),
        ),
      ),
      onConfirm: (DateTime date, List<int> list) {
        _date = date;
        _currentButton = 1;

        setState(() {});
      },
    );
  }

  ///Show the purchase information with
  ///the price and date.
  Widget _purchaseConfirmation(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${widget.lesson.priceHour}\$ / 1 hour",
              style: _theme.textTheme.subtitle1.copyWith(
                color: _theme.accentColor,
              ),
            ),
            SizedBox(height: screenAwareHeight(5, context)),
            Text(
              "${Jiffy(_date.toString(), "yyyy-MM-dd").format("MMM do")} at ${Jiffy(_date.toString(), "yyyy-MM-dd").format("h:mm")}",
              style: _theme.textTheme.subtitle1.copyWith(
                color: _theme.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
