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
    return matchList.length == 0 ? Loading() : ListView.builder(
        itemCount: matchList.length,
        itemBuilder: (context, index){
          return Padding(
              padding: EdgeInsets.all(10),
            child: UpcomingScheduleCard(match: matchList[index]),
          );
        }
    );
  }
}
