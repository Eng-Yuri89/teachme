import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/ui/screens/teacher/teacher_detail.dart';
import 'package:teachme/utils/size.dart';
import 'package:uuid/uuid.dart';

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
      resume: "Teaches Photography and Video Production",
      description: "Improve your UX skills and a couple of sessions.",
      photoUrl:
          "https://dreamstop.com/wp-content/uploads/2013/07/teacher-dream-meaning.jpg",
    ),
    Teacher(
      id: "125",
      email: "juanperez@gmail.com",
      fullname: "Juan Perez",
      phoneNumber: "+502 30344591",
      resume: "Teaches Photography and Video Production",
      description: "Improve your UX skills and a couple of sessions.",
      photoUrl:
          "https://dreamstop.com/wp-content/uploads/2013/07/teacher-dream-meaning.jpg",
    ),
    Teacher(
      id: "127",
      email: "pedrosalazar@gmail.com",
      fullname: "Pedro Salazar",
      phoneNumber: "+502 98765434",
      resume: "Teaches Photography and Video Production",
      description: "Improve your UX skills and a couple of sessions.",
      photoUrl:
          "https://dreamstop.com/wp-content/uploads/2013/07/teacher-dream-meaning.jpg",
    )
  ];
  //Top Rated list.
  List<Teacher> _topList = [
    Teacher(
      id: "123",
      email: "angelcabrera18398@gmail.com",
      fullname: "Angel Cabrera",
      phoneNumber: "+502 30435391",
      resume: "Teaches Photography and Video Production",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
    ),
    Teacher(
      id: "125",
      email: "juanperez@gmail.com",
      fullname: "Juan Perez",
      phoneNumber: "+502 30344591",
      resume: "Teaches Photography and Video Production",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
    ),
    Teacher(
      id: "127",
      email: "pedrosalazar@gmail.com",
      fullname: "Pedro Salazar",
      phoneNumber: "+502 98765434",
      resume: "Teaches Photography and Video Production",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
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
            _recommendedListView(context),
            //Top rated title.
            _topRatedTitle(context),
            //Top rated list.
            _topListView(context)
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
    //Unique hero key.
    final String _heroKey = "TeacherImage-${new Uuid().v4()}";

    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Teacher image.
          Hero(
            tag: _heroKey,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenAwareWidth(5, context)),
              child: FadeInImage(
                fit: BoxFit.fill,
                width: screenAwareWidth(196, context),
                height: screenAwareHeight(120, context),
                placeholder: AssetImage("assets/home/loading.gif"),
                image: NetworkImage(teacher.photoUrl),
              ),
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
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => (TeacherDetail(
              teacher: teacher,
              heroKey: _heroKey,
            )),
          ),
        );
      },
    );
  }

  ///Returns the top rated title
  Widget _topRatedTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareWidth(20, context),
        right: screenAwareWidth(20, context),
        top: screenAwareHeight(40, context),
        bottom: screenAwareWidth(20, context),
      ),
      child: Text(
        "Top Rated",
        style: _theme.textTheme.headline6.copyWith(
          color: _theme.backgroundColor,
        ),
      ),
    );
  }

  /// Returns the top rated list view
  /// separated.
  Widget _topListView(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(screenAwareWidth(20, context)),
        itemCount: _topList.length,
        itemBuilder: (BuildContext context, int index) {
          return _topCard(context, _topList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: _theme.backgroundColor.withOpacity(0.25));
        },
      ),
    );
  }

  /// Returns the top rated teacher
  /// card with relevant information.
  Widget _topCard(BuildContext context, Teacher teacher) {
    //Unique hero key.
    final String _heroKey = "TeacherImage-${new Uuid().v4()}";

    return InkWell(
      child: Row(
        children: <Widget>[
          //Teacher image.
          _topCardImage(context, teacher, _heroKey),
          SizedBox(width: screenAwareWidth(15, context)),
          Container(
            height: screenAwareHeight(100, context),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Header card.
                _topCardHeader(context, teacher),
                //Teacher description.
                Container(
                  height: screenAwareHeight(38, context),
                  width: screenAwareWidth(260, context),
                  child: AutoSizeText(
                    teacher.description,
                    style: _theme.textTheme.bodyText2.copyWith(
                      color: _theme.backgroundColor.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                _topCartFooter(context, teacher),
              ],
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => (TeacherDetail(
              teacher: teacher,
              heroKey: _heroKey,
            )),
          ),
        );
      },
    );
  }

  ///Return the top rated card image.
  Widget _topCardImage(BuildContext context, Teacher teacher, String heroKey) {
    return Hero(
      tag: heroKey,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenAwareWidth(5, context)),
        child: FadeInImage(
          fit: BoxFit.fill,
          height: screenAwareHeight(100, context),
          width: screenAwareWidth(60, context),
          placeholder: AssetImage("assets/home/loading.gif"),
          image: NetworkImage(teacher.photoUrl),
        ),
      ),
    );
  }

  ///Returns the teacher's name and the
  ///favorite button add.
  Widget _topCardHeader(BuildContext context, Teacher teacher) {
    return Container(
      width: screenAwareWidth(260, context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Teacher name.
          Text(
            teacher.fullname,
            style: _theme.textTheme.subtitle1.copyWith(
              color: _theme.backgroundColor,
            ),
          ),
          //Favorite button.
          Image.asset(
            "assets/landing/favorite.png",
            fit: BoxFit.fill,
            width: screenAwareWidth(16, context),
          )
        ],
      ),
    );
  }

  ///Returns the teacher rated and the
  ///number of classes.
  Widget _topCartFooter(BuildContext context, Teacher teacher) {
    return Row(
      children: <Widget>[
        //Rated.
        Text(
          "4.5",
          style: _theme.textTheme.subtitle2.copyWith(
            color: _theme.backgroundColor,
          ),
        ),
        SizedBox(width: screenAwareWidth(3, context)),
        //Star icon.
        Icon(
          Icons.star,
          size: screenAwareWidth(16, context),
          color: Color.fromRGBO(66, 99, 235, 1),
        ),
        SizedBox(width: screenAwareWidth(6, context)),
        //Class number.
        Text(
          "125 Classes",
          style: _theme.textTheme.caption.copyWith(
            color: _theme.backgroundColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
