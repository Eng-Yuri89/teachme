import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/utils/size.dart';

/// Home screen
///
/// Main page showing the recommended
/// and best ranked courses.
class HomeScreen extends StatelessWidget {
  //Global theme.
  ThemeData _theme;
  // Recommended list.
  List<Teacher> _recommendedList = [
    Teacher(
      id: "123",
      email: "angelcabrera18398@gmail.com",
      fullname: "Angel Cabrera",
      phoneNumber: "+502 30435391",
      description:
          "Improve your UX skills and a couple of sessions Improve your UX skills and a couple of sessions Improve your UX skills and a couple of sessions.",
      photoUrl:
          "https://dreamstop.com/wp-content/uploads/2013/07/teacher-dream-meaning.jpg",
    ),
    Teacher(
      id: "125",
      email: "juanperez@gmail.com",
      fullname: "Juan Perez",
      phoneNumber: "+502 30344591",
      description: "Improve your UX skills and a couple of sessions.",
      photoUrl:
          "https://dreamstop.com/wp-content/uploads/2013/07/teacher-dream-meaning.jpg",
    ),
    Teacher(
      id: "127",
      email: "pedrosalazar@gmail.com",
      fullname: "Pedro Salazar",
      phoneNumber: "+502 98765434",
      description: "Improve your UX skills and a couple of sessions.",
      photoUrl:
          "https://dreamstop.com/wp-content/uploads/2013/07/teacher-dream-meaning.jpg",
    )
  ];

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Page header.
            _pageHeader(context),
            //Recommended teacher list.
            _recommendedListView(context)
          ],
        ),
      ),
    );
  }

  ///Returns the title of the page.
  Widget _pageHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareWidth(20, context),
        right: screenAwareWidth(20, context),
        bottom: screenAwareWidth(20, context),
        top: screenAwareWidth(30, context),
      ),
      child: Text(
        "Recommended",
        style: _theme.textTheme.headline6.copyWith(
          color: _theme.backgroundColor,
        ),
      ),
    );
  }

  /// Returns the list of recommended teachers.
  Widget _recommendedListView(BuildContext context) {
    return Container(
      width: double.infinity,
      height: screenAwareWidth(180, context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(20, context),
        ),
        itemCount: _recommendedList.length,
        itemBuilder: (BuildContext context, int index) {
          return _recomemendedCard(context, _recommendedList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: screenAwareWidth(20, context),
          );
        },
      ),
    );
  }

  /// Returns the teacher recommended card.
  Widget _recomemendedCard(BuildContext context, Teacher teacher) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Teacher image.
        ClipRRect(
          borderRadius: BorderRadius.circular(screenAwareWidth(5, context)),
          child: Image(
            image: NetworkImage(teacher.photoUrl),
            fit: BoxFit.fill,
            width: screenAwareWidth(196, context),
            height: screenAwareHeight(120, context),
          ),
        ),
        SizedBox(height: screenAwareHeight(10, context)),
        //Teacher name.
        Text(
          teacher.fullname,
          style: _theme.textTheme.subtitle1.copyWith(
            color: _theme.accentColor,
          ),
        ),
        SizedBox(height: screenAwareHeight(10, context)),
        Container(
          width: screenAwareWidth(196, context),
          height: screenAwareHeight(40, context),
          child: AutoSizeText(
            teacher.description,
            style: _theme.textTheme.bodyText2.copyWith(
              color: _theme.accentColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.left,
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}
