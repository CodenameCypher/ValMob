import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/models/team.dart';
import 'package:valmob/services/teams.dart';
import 'package:valmob/screens/teams/teamsListView.dart';

class TeamsView extends StatelessWidget {
  const TeamsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Team>>.value(
        value: Teams().getTeamStream,
        initialData: [],
      child: TeamsListView(),
    );
  }
}
