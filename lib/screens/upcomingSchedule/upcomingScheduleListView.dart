import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/screens/upcomingSchedule/upcomingScheduleCard.dart';
import 'package:valmob/shared/loading.dart';
import 'package:valmob/models/matches.dart' as model;

class UpcomingScheduleListView extends StatefulWidget {
  const UpcomingScheduleListView({Key? key}) : super(key: key);

  @override
  State<UpcomingScheduleListView> createState() => _UpcomingScheduleListViewState();
}

class _UpcomingScheduleListViewState extends State<UpcomingScheduleListView> {
  @override
  Widget build(BuildContext context) {
    final List<model.Match> matchList = Provider.of<List<model.Match>>(context);
    return matchList.length < 50 ? Loading() : ListView.builder(
        itemCount: matchList.length,
        itemBuilder: (context, index){
          return matchList[index].eta != "LIVE" && DateTime.parse(matchList[index].match_time).compareTo(DateTime.now()) < 0 ? SizedBox(height: 0,) : Padding(
              padding: EdgeInsets.all(10),
            child: UpcomingScheduleCard(match: matchList[index]),
          );
        }
    );
  }
}
