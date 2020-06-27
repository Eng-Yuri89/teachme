import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teachme/models/mail.dart';
import 'package:teachme/models/profile.dart';
import 'package:teachme/models/user.dart';
import 'package:teachme/models/voclients.dart';
import 'package:teachme/ui/screens/home/all_mails_screen.dart';
import 'package:teachme/services/db.dart';
import 'package:teachme/ui/widgets/mail_card.dart';
import 'package:teachme/ui/widgets/main_button.dart';
import 'package:teachme/ui/widgets/stadistics_card.dart';
import 'package:teachme/utils/helper_functions.dart';
import 'package:teachme/utils/size.dart';
import 'package:provider/provider.dart';

/// Home screen.
///
/// Page where you can see a summary of
/// all emails according to their status.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Query Date filters
  DateTime startDate = DateTime.utc(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - 1, 0, 0, 0);
  DateTime endDate = DateTime.utc(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 59, 59);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<VOClients>>(
        stream: Provider.of<DatabaseService>(context)
            .streamVOClients(Provider.of<Profile>(context)?.email),
        builder: (BuildContext context,
            AsyncSnapshot<List<VOClients>> officeSnapshot) {
          if (!officeSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.4),
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            );
          } else {
            return officeSnapshot.data.length > 0
                ? _fullResults(context, officeSnapshot.data)
                : _emptyResults(context);
          }
        },
      ),
    );
  }

  /// Retunrs the results of the user.
  Widget _fullResults(BuildContext context, List<VOClients> offices) {
    return StreamBuilder<List<Mail>>(
      stream: Provider.of<DatabaseService>(context).getMailByOficess(offices),
      builder: (BuildContext context, AsyncSnapshot<List<Mail>> mailSnapshot) {
        if (!mailSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).primaryColor,
              ),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Page header.
                _pageHeader(context),
                SizedBox(height: screenAwareHeight(36, context)),
                // Date information.
                _dateInfo(context),
                SizedBox(height: screenAwareHeight(10, context)),
                // Stadistics information.
                _stadistics(
                  context: context,
                  officesLength: offices.length,
                  mailLength: mailSnapshot.data.length,
                  unresolvedLength: mailSnapshot.data
                      .where(
                          (mail) => mail.status.toUpperCase() == "IN PROGRESS")
                      .toList()
                      .length,
                ),
                SizedBox(height: screenAwareHeight(33, context)),
                // Recents mails resume.
                _resentMails(
                  context,
                  mailSnapshot.data,
                  offices,
                ),
                // In Progress mails resume.
                _unresolvedMails(
                  context,
                  mailSnapshot.data,
                  offices,
                ),
                SizedBox(height: screenAwareHeight(36, context)),
                // Delivered mails resume.
                _resolvedMails(
                  context,
                  mailSnapshot.data,
                  offices,
                ),
                SizedBox(height: screenAwareHeight(30, context))
              ],
            ),
          );
        }
      },
    );
  }

  /// Returns empty information.
  Widget _emptyResults(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page header.
        _pageHeader(context),
        SizedBox(height: screenAwareHeight(36, context)),
        // Date information.
        _dateInfo(context),
        SizedBox(height: screenAwareHeight(100, context)),
        Center(
          child: SvgPicture.asset(
            "assets/empty.svg",
            fit: BoxFit.fill,
            width: screenAwareWidth(253, context),
            height: screenAwareHeight(198, context),
          ),
        ),
        SizedBox(height: screenAwareHeight(80, context)),
        // Help text information.
        Center(
          child: Text(
            "No tiene invitaciones aún \nContacte la administración \npara agregar nuevos sitios ",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(16, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
        )
      ],
    );
  }

  /// Return the page header.
  Widget _pageHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenAwareHeight(50, context)),
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Circle avatar.
          CircleAvatar(
            radius: screenAwareWidth(17, context),
            backgroundImage: NetworkImage(
                "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"),
          ),
          SizedBox(width: screenAwareWidth(5, context)),
          // Greeting for the user.
          Flexible(
            child: AutoSizeText(
              "Hello ${Provider.of<Profile>(context)?.firstName ?? ""}!",
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontSize: screenAwareWidth(30, context),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Return the date information.
  Widget _dateInfo(BuildContext context) {
    // Date.
    final _date = Jiffy().format("do MMM, yyyy");

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Calendar icon.
          SvgPicture.asset("assets/calendar.svg",
              fit: BoxFit.fill, width: screenAwareWidth(15, context)),
          SizedBox(width: screenAwareWidth(4, context)),
          // Date information.
          Text(
            "Today is $_date",
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: screenAwareWidth(10, context),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          )
        ],
      ),
    );
  }

  /// Return the recent title and list.
  Widget _resentMails(
      BuildContext context, List<Mail> list, List<VOClients> offices) {
    final _filterList = list
        .where(
          (mail) =>
              DateTime.fromMillisecondsSinceEpoch(
                      mail.dateTime.millisecondsSinceEpoch)
                  .isAfter(startDate) &&
              DateTime.fromMillisecondsSinceEpoch(
                      mail.dateTime.millisecondsSinceEpoch)
                  .isBefore(endDate),
        )
        .toList();

    return Visibility(
      visible: _filterList.length > 0 ? true : false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Recent header.
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Recent title.
                Text(
                  "Recent",
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                    fontSize: screenAwareWidth(22, context),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(width: screenAwareWidth(35, context)),
                // View all link.
                _viewAllLink(context, offices)
              ],
            ),
          ),
          SizedBox(height: screenAwareHeight(20, context)),
          // Recent mails list.
          _recentMailsList(context, _filterList),
          SizedBox(height: screenAwareHeight(36, context))
        ],
      ),
    );
  }

  /// Return the recent mails list.
  Widget _recentMailsList(BuildContext context, List<Mail> list) {
    return Container(
      width: double.infinity,
      height: screenAwareHeight(186, context),
      padding: EdgeInsets.only(
        left: screenAwareWidth(30, context),
        top: screenAwareHeight(5, context),
        bottom: screenAwareHeight(5, context),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => MailCard(mail: list[index]),
        separatorBuilder: (context, index) =>
            SizedBox(width: screenAwareWidth(20, context)),
        itemCount: list.length,
      ),
    );
  }

  /// Return the in progress title and list.
  Widget _unresolvedMails(
      BuildContext context, List<Mail> list, List<VOClients> offices) {
    final _filterList = list
        .where((mail) => mail.status.toUpperCase() == "IN PROGRESS")
        .toList();

    return Visibility(
      visible: _filterList.length > 0 ? true : false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // In Progress header.
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // In Progress title.
                Text(
                  "Unresolved Mail",
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                    fontSize: screenAwareWidth(22, context),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(width: screenAwareWidth(35, context)),
                // View all link.
                _viewAllLink(context, offices)
              ],
            ),
          ),
          SizedBox(height: screenAwareHeight(20, context)),
          // In Progress mails list.
          _unresolvedMailsList(context, _filterList)
        ],
      ),
    );
  }

  /// Return the in progress mails list.
  Widget _unresolvedMailsList(BuildContext context, List<Mail> list) {
    return Container(
      width: double.infinity,
      height: screenAwareHeight(186, context),
      padding: EdgeInsets.only(
        left: screenAwareWidth(30, context),
        top: screenAwareHeight(5, context),
        bottom: screenAwareHeight(5, context),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => MailCard(mail: list[index]),
        separatorBuilder: (context, index) => SizedBox(
          width: screenAwareWidth(20, context),
        ),
        itemCount: list.length,
      ),
    );
  }

  /// Return the in delivered title and list.
  Widget _resolvedMails(
      BuildContext context, List<Mail> list, List<VOClients> offices) {
    final _filterList =
        list.where((mail) => mail.status.toUpperCase() == "DELIVERED").toList();

    return Visibility(
      visible: _filterList.length > 0 ? true : false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Delivered header.
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: screenAwareWidth(30, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Delivered title.
                Text(
                  "Resolved Mail",
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                    fontSize: screenAwareWidth(22, context),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(width: screenAwareWidth(35, context)),
                // View all link.
                _viewAllLink(context, offices)
              ],
            ),
          ),
          SizedBox(height: screenAwareHeight(20, context)),
          // In Progress mails list.
          _resolvedMailsList(context, _filterList)
        ],
      ),
    );
  }

  /// Return the in delivered mails list.
  Widget _resolvedMailsList(BuildContext context, List<Mail> list) {
    return Container(
      width: double.infinity,
      height: screenAwareHeight(186, context),
      padding: EdgeInsets.only(
          left: screenAwareWidth(30, context),
          top: screenAwareHeight(5, context),
          bottom: screenAwareHeight(5, context)),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => MailCard(mail: list[index]),
        separatorBuilder: (context, index) => SizedBox(
          width: screenAwareWidth(20, context),
        ),
        itemCount: list.length,
      ),
    );
  }

  /// Returns the text ViewAll that
  /// shows the page of all emails.
  Widget _viewAllLink(BuildContext context, List<VOClients> offices) {
    return Consumer<User>(
      builder: (BuildContext context, User user, Widget child) {
        return MainButton(
          isLoading: false,
          enabledColor: Theme.of(context).buttonColor,
          onTap: () {
            navigateTo(context, AllMailScreen(user: user, offices: offices));
          },
          child: Text(
            "View All",
            style: TextStyle(
              color: Color(0xfffefefe),
              fontSize: screenAwareWidth(9, context),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
          enabled: true,
          width: screenAwareWidth(75, context),
          height: screenAwareHeight(20, context),
        );
      },
    );
  }

  /// Returns the stadistics of the account.
  Widget _stadistics({
    BuildContext context,
    int officesLength,
    int mailLength,
    int unresolvedLength,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenAwareWidth(30, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Mail stadistics.
              Flexible(
                child: StadisticsCard(title: "All Mail", count: mailLength),
              ),
              SizedBox(
                width: screenAwareHeight(14, context),
              ),
              // Offices stadistics.
              Flexible(
                child: StadisticsCard(title: "Offices", count: officesLength),
              ),
            ],
          ),
          SizedBox(
            height: screenAwareHeight(14, context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Mail stadistics.
              Flexible(
                child: StadisticsCard(
                    title: "Unresolved", count: unresolvedLength),
              ),
              SizedBox(
                width: screenAwareHeight(14, context),
              ),
              // Offices stadistics.
              Flexible(
                child: StadisticsCard(title: "Notifications", count: 2),
              ),
            ],
          )
        ],
      ),
    );
  }
}
