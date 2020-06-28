import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teachme/models/lesson.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/utils/size.dart';

class TeacherDetail extends StatefulWidget {
  TeacherDetail({Key key, @required this.teacher, @required this.heroKey});

  final Teacher teacher;
  final String heroKey;

  @override
  _TeacherDetailState createState() => _TeacherDetailState();
}

class _TeacherDetailState extends State<TeacherDetail> {
  ThemeData _theme;
  int _selectedIndex = 0;
  List<double> _positiones = [0.00, 0.50];
  double _position = 0;
  PageController _controller = new PageController(
    initialPage: 0,
  );
  List<Lesson> _lessonList = [
    Lesson(
      title: "Single Photography Mentoring",
      description: "Best techniques, improve your camera settings",
      priceHour: 12,
      isSelected: false,
    ),
    Lesson(
      title: "Single Photography Mentoring",
      description: "Best techniques, improve your camera settings",
      priceHour: 12,
      isSelected: false,
    ),
    Lesson(
      title: "Single Photography Mentoring",
      description: "Best techniques, improve your camera settings",
      priceHour: 12,
      isSelected: false,
    ),
    Lesson(
      title: "Single Photography Mentoring",
      description: "Best techniques, improve your camera settings",
      priceHour: 12,
      isSelected: false,
    )
  ];

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;
    _theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: screenAwareHeight(_screen.height * 0.62, context),
              width: _screen.width,
              child: _pageHeader(context),
            ),
            _bottomPageView(context),
          ],
        ),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenAwareWidth(5, context)),
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: AssetImage("assets/home/loading.gif"),
              image: NetworkImage(widget.teacher.photoUrl),
            ),
          ),
        ),
        Image.asset(
          'assets/teacher/gradient.png',
          fit: BoxFit.fill,
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: screenAwareHeight(360, context),
            ),
            //Teacher name.
            Text(
              widget.teacher.fullname,
              style: _theme.textTheme.headline4.copyWith(
                color: _theme.accentColor,
              ),
            ),
            SizedBox(
              height: screenAwareHeight(15, context),
            ),
            Container(
              width: screenAwareWidth(350, context),
              height: screenAwareHeight(50, context),
              child: AutoSizeText(
                widget.teacher.resume,
                style: _theme.textTheme.subtitle1.copyWith(
                  color: _theme.accentColor,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        )
      ],
    );
  }

  ///Returns the page view with
  ///short description of the
  ///teacher and lessons.
  Widget _bottomPageView(BuildContext context) {
    return Column(
      children: <Widget>[
        _topTab(context),
        Container(
          width: double.infinity,
          height: screenAwareHeight(250, context),
          child: PageView(
            controller: _controller,
            onPageChanged: (int index) {
              _changeIndex(index);
            },
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _aboutMePage(context),
              _lessonsPage(context),
            ],
          ),
        )
      ],
    );
  }

  ///Top navigatoin tab.
  Widget _topTab(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: screenAwareHeight(15, context),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //About me tab.
              InkWell(
                child: Text(
                  "ABOUT ME",
                  style: _theme.textTheme.subtitle2.copyWith(
                    color: _selectedIndex == 0
                        ? _theme.primaryColor
                        : _theme.accentColor.withOpacity(0.8),
                  ),
                ),
                onTap: () {
                  _changeIndex(0);
                },
              ),
              //Lessons tab.
              InkWell(
                child: Text(
                  "LESSONS",
                  style: _theme.textTheme.subtitle2.copyWith(
                    color: _selectedIndex == 1
                        ? _theme.primaryColor
                        : _theme.accentColor.withOpacity(0.8),
                  ),
                ),
                onTap: () {
                  _changeIndex(1);
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenAwareHeight(15, context),
        ),
        Stack(
          children: <Widget>[
            Container(
              height: screenAwareHeight(2, context),
              color: _theme.accentColor.withOpacity(0.8),
            ),
            AnimatedContainer(
              margin: EdgeInsets.only(left: _position),
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOutSine,
              height: screenAwareHeight(2, context),
              width: MediaQuery.of(context).size.width * 0.5,
              color: _theme.primaryColor,
            )
          ],
        )
      ],
    );
  }

  ///Change de current index
  void _changeIndex(int index) {
    _selectedIndex = index;
    _position = MediaQuery.of(context).size.width * _positiones[index];

    setState(() {});

    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutSine,
    );
  }

  ///Returns the about me page.
  Widget _aboutMePage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(20, context),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: screenAwareHeight(47, context),
          ),
          Text(
            widget.teacher.description,
            style: _theme.textTheme.bodyText1.copyWith(
              color: _theme.accentColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  ///Returns the lessons page.
  Widget _lessonsPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(20, context),
      ),
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _lessonCard(context, _lessonList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: _theme.backgroundColor.withOpacity(0.25));
        },
        itemCount: _lessonList.length,
      ),
    );
  }

  ///Lesson card
  Widget _lessonCard(BuildContext context, Lesson lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Lesson title.
        Text(
          lesson.title,
          style: _theme.textTheme.subtitle2.copyWith(
            color: _theme.accentColor,
          ),
        ),
        SizedBox(height: screenAwareHeight(15, context)),
        Text(
          lesson.description,
          style: _theme.textTheme.bodyText1.copyWith(
            color: _theme.accentColor.withOpacity(0.8),
          ),
        ),
        SizedBox(height: screenAwareHeight(15, context)),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "${lesson.priceHour}\$",
              style: _theme.textTheme.subtitle1.copyWith(
                color: _theme.accentColor,
              ),
            ),
            Text(
              " / 1 hour",
              style: _theme.textTheme.bodyText2.copyWith(
                color: _theme.accentColor.withOpacity(0.8),
              ),
            ),
            Expanded(child: Container()),
            MainButton(
              enabledColor: _theme.primaryColor,
              disableColor: Color.fromRGBO(116, 115, 131, 1),
              onTap: () {
                lesson.isSelected = !lesson.isSelected;

                setState(() {});
              },
              child: Text(
                "CHOOSE",
                style: _theme.textTheme.overline.copyWith(
                  color: _theme.accentColor,
                ),
              ),
              enabled: lesson.isSelected ? false : true,
              height: screenAwareHeight(37, context),
              width: screenAwareWidth(110, context),
              isLoading: false,
              borderRadius: screenAwareWidth(5, context),
            ),
          ],
        ),
        SizedBox(
          height: screenAwareHeight(5, context),
        ),
      ],
    );
  }
}
