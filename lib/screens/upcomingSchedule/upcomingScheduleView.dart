import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/services/matches.dart';
import 'package:valmob/screens/upcomingSchedule/upcomingScheduleListView.dart';
import 'package:valmob/models/matches.dart' as model;

class UpcomingScheduleView extends StatelessWidget {
  const UpcomingScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<model.Match>>.value(
        value: Matches().getMatch,
        initialData: [],
        child: UpcomingScheduleListView(),
    );
  }
}
