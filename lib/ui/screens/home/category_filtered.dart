import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/models/teacher_favorite.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/screens/teacher/teacher_detail.dart';
import 'package:teachme/utils/size.dart';
import 'package:uuid/uuid.dart';

class CategoryFiltered extends StatelessWidget {
  final String category;
  final User user;
  ThemeData _theme;

  CategoryFiltered({@required this.category, this.user});

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: _filterListView(context),
      ),
    );
  }

  /// Returns the filter list view
  /// separated.
  Widget _filterListView(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<DatabaseService>(context).getFavoriteTeacher(user),
      builder: (BuildContext context,
          AsyncSnapshot<List<TeacherFavorite>> favSnapshot) {
        if (favSnapshot.connectionState == ConnectionState.active) {
          if (favSnapshot.hasData) {
            return StreamBuilder<List<Teacher>>(
              stream: Provider.of<DatabaseService>(context)
                  .getCategoryTeacher(category, favSnapshot.data),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Teacher>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    return ListView.separated(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(screenAwareWidth(20, context)),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _filterCard(context, snapshot.data[index], user);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                            color: _theme.backgroundColor.withOpacity(0.25));
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No teachers were found in this category",
                        style: _theme.textTheme.bodyText2.copyWith(
                          color: _theme.accentColor.withOpacity(0.8),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: Text(
                "No teachers were found in this category",
                style: _theme.textTheme.bodyText2.copyWith(
                  color: _theme.accentColor.withOpacity(0.8),
                ),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.4),
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          );
        }
      },
    );
  }

  /// The filter teacher returns
  /// card with relevant information.
  Widget _filterCard(BuildContext context, Teacher teacher, User user) {
    //Unique hero key.
    final String _heroKey = "TeacherImage-${new Uuid().v4()}";

    return InkWell(
      child: Row(
        children: <Widget>[
          //Teacher image.
          _filterCardImage(context, teacher, _heroKey),
          SizedBox(width: screenAwareWidth(15, context)),
          Container(
            height: screenAwareHeight(100, context),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Header card.
                _filterCardHeader(context, teacher, user),
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
                _filterCardFooter(context, teacher),
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

  ///Return the filter card image.
  Widget _filterCardImage(
      BuildContext context, Teacher teacher, String heroKey) {
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
  Widget _filterCardHeader(BuildContext context, Teacher teacher, User user) {
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
          InkWell(
            child: Image.asset(
              teacher.isFavorite
                  ? "assets/favorite/favorite.png"
                  : "assets/landing/favorite.png",
              fit: BoxFit.fill,
              width: screenAwareWidth(16, context),
            ),
            onTap: () async {
              DatabaseService _data = new DatabaseService();
              final _id = teacher.isFavorite
                  ? teacher.favoriteId
                  : new Uuid().v1().toString();

              if (!teacher.isFavorite) {
                await _data.addFavoriteTeacher(teacher.id, user.uid, _id);
              } else {
                await _data.removeFavorite(_id);
              }
            },
          )
        ],
      ),
    );
  }

  ///Returns the teacher rated and the
  ///number of classes.
  Widget _filterCardFooter(BuildContext context, Teacher teacher) {
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
