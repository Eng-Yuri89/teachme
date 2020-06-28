import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:teachme/models/teacher.dart';
import 'package:teachme/utils/size.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScrenState createState() => _FavoriteScrenState();
}

class _FavoriteScrenState extends State<FavoriteScreen> {
  bool _isFavorite = false;

  static ThemeData _theme;

  //Favorite list.
  List<Teacher> _topList = [
    Teacher(
      id: "123",
      email: "angelcabrera18398@gmail.com",
      fullname: "Angel Cabrera",
      phoneNumber: "+502 30435391",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
    ),
    Teacher(
      id: "125",
      email: "juanperez@gmail.com",
      fullname: "Juan Perez",
      phoneNumber: "+502 30344591",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
    ),
    Teacher(
      id: "127",
      email: "pedrosalazar@gmail.com",
      fullname: "Pedro Salazar",
      phoneNumber: "+502 98765434",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
    ),
    Teacher(
      id: "125",
      email: "juanperez@gmail.com",
      fullname: "Juan Perez",
      phoneNumber: "+502 30344591",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
    ),
    Teacher(
      id: "125",
      email: "juanperez@gmail.com",
      fullname: "Juan Perez",
      phoneNumber: "+502 30344591",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
    ),
    Teacher(
      id: "125",
      email: "juanperez@gmail.com",
      fullname: "Juan Perez",
      phoneNumber: "+502 30344591",
      description: "Software Engineer, 5 years mobile development experience.",
      photoUrl:
          "https://i.pinimg.com/originals/73/d3/1c/73d31c1a205363fa75e8c8834d3f1166.jpg",
    ),
  ];

  TextEditingController _filterController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _filterInput(context),
            _optionHeader("Favorites", context),
            _topListView(context),
          ],
        ),
      ),
    );
  }

  Widget _filterInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenAwareWidth(20, context),
          vertical: screenAwareHeight(30, context)),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: screenAwareWidth(15, context)),
        height: screenAwareHeight(50, context),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(26, 27, 29, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Search icon
            Image.asset("assets/landing/search_active.png",
                fit: BoxFit.fill, width: screenAwareHeight(25, context)),
            SizedBox(width: screenAwareWidth(10, context)),
            // Filter text or filters selected.
            Expanded(
              child: TextFormField(
                controller: _filterController,
                autofocus: false,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  suffixIcon: _filterController.text == ""
                      ? Container(width: 0, height: 0)
                      : InkWell(
                          child: Icon(Icons.close),
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _filterController.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {});
                            });
                          }),
                  contentPadding: EdgeInsets.fromLTRB(
                      0,
                      screenAwareHeight(15, context),
                      screenAwareWidth(10, context),
                      screenAwareHeight(0, context)),
                  border: InputBorder.none,
                  hintText: "Search a teacher",
                  hintStyle: TextStyle(
                    color: _theme.backgroundColor.withOpacity(0.50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Option header creation
  Widget _optionHeader(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(20, context)),
      child: Text(
        title,
        style: _theme.textTheme.headline6.copyWith(
          color: _theme.backgroundColor,
        ),
      ),
    );
  }

  /// Returns the favorites list view
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

  /// The favorite teacher returns
  /// card with relevant information.
  Widget _topCard(BuildContext context, Teacher teacher) {
    return Row(
      children: <Widget>[
        //Teacher image.
        _topCardImage(context, teacher),
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
    );
  }

  ///Return the favorite card image.
  Widget _topCardImage(BuildContext context, Teacher teacher) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(screenAwareWidth(5, context)),
      child: FadeInImage(
        fit: BoxFit.fill,
        height: screenAwareHeight(100, context),
        width: screenAwareWidth(60, context),
        placeholder: AssetImage("assets/home/loading.gif"),
        image: NetworkImage(teacher.photoUrl),
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
          InkWell(
            child: Image.asset(
              _isFavorite
                  ? "assets/favorite/favorite.png"
                  : "assets/landing/favorite.png",
              fit: BoxFit.fill,
              width: screenAwareWidth(16, context),
            ),
            onTap: () {
              _isFavorite = !_isFavorite;

              setState(() {});
            },
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
