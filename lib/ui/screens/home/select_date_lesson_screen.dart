import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teachme/models/lesson.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/utils/size.dart';

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
          _lessonDescription(context)
        ],
      ),
      bottomNavigationBar: _bottomButton(context),
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
  Widget _bottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
      child: MainButton(
        enabledColor: _theme.primaryColor,
        disableColor: Color.fromRGBO(116, 115, 131, 1),
        child: Text(
          "SELECT A DATE",
          style: _theme.textTheme.button.copyWith(
            color: _theme.accentColor,
          ),
        ),
        enabled: true,
        height: screenAwareHeight(50, context),
        isLoading: false,
        borderRadius: screenAwareWidth(5, context),
        onTap: () {},
      ),
    );
  }
}
