import 'package:flutter/material.dart';
import 'package:valmob/screens/devDiary/devView.dart';
import 'package:valmob/screens/news/newsView.dart';
import 'package:valmob/screens/teams/teamsView.dart';
import 'package:valmob/screens/upcomingSchedule/upcomingScheduleView.dart';
import 'package:valmob/services/matches.dart';
import 'package:valmob/services/news.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:valmob/services/teams.dart';
import 'package:valmob/shared/loading.dart';
import 'package:valmob/test/test.dart';
import 'package:valmob/shared/theme.dart' as shared;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  int _bottomNavIndex = 0;
  List<Widget> widgetList = [
    NewsView(),
    UpcomingScheduleView(),
    TeamsView(),
    DevView()
  ];
  @override
  Widget build(BuildContext context) {
    // News().updateDatabase();
    // Matches().updateDatabase();
    return Scaffold(
      backgroundColor: shared.Theme.swatch1,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20)
          )
        ),
        centerTitle: true,
        title: Text(
          "vAlMOB", 
          style: TextStyle(
            fontFamily: 'ValFont',
            fontSize: 25,
          ),
        ),
        backgroundColor: shared.Theme.swatch2,
        elevation: 0,
      ),
      body: widgetList[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: shared.Theme.swatch6,
        child: Icon(Icons.refresh),
        onPressed: () async{
          print('action button pressed');
          if(_bottomNavIndex == 0) {
            News().updateDatabase();
            SmartDialog.showLoading(builder: (_) => Loading());
            await Future.delayed(Duration(seconds: 1));
            SmartDialog.dismiss();
          }
          else if(_bottomNavIndex == 1) {
            Matches().updateDatabase();
            SmartDialog.showLoading(builder: (_) => Loading());
            await Future.delayed(Duration(seconds: 3));
            SmartDialog.dismiss();
          }
          else if(_bottomNavIndex == 2) {
            Teams().updateDatabase();
            SmartDialog.showLoading(builder: (_) => Loading());
            await Future.delayed(Duration(seconds: 3));
            SmartDialog.dismiss();
          }
          // Test().test();
        },

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [Icons.newspaper_rounded ,Icons.calendar_month, Icons.groups_sharp,Icons.construction],
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        backgroundColor: shared.Theme.swatch2,
        inactiveColor: Colors.grey,
        activeColor: Colors.white,
        splashRadius: 16,
        splashColor: shared.Theme.swatch6,
      ),
    );
  }
}
