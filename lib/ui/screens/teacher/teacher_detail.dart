import 'package:flutter/material.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/utils/size.dart';

class TeacherDetail extends StatelessWidget {
  const TeacherDetail({Key key, this.teacher}) : super(key: key);

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;
    final _theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: screenAwareHeight(_screen.height * 0.62, context),
              width: _screen.width,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    'assets/teacher/teacher_detail.png',
                    fit: BoxFit.fitHeight,
                  ),
                  Image.asset(
                    'assets/teacher/gradient.png',
                    fit: BoxFit.fitHeight,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        teacher.fullname,
                        style: _theme.textTheme.headline4,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
