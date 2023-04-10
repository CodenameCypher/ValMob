import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/models/team.dart';
import 'package:valmob/screens/teams/teamsCard.dart';
import 'package:valmob/shared/loading.dart';


class TeamsListView extends StatefulWidget {
  const TeamsListView({Key? key}) : super(key: key);

  @override
  State<TeamsListView> createState() => _TeamsListViewState();
}

class _TeamsListViewState extends State<TeamsListView> {
  @override
  Widget build(BuildContext context) {
    List<Team> teamsList = Provider.of<List<Team>>(context);
    return teamsList.length <= 30 ? Loading() : ListView.builder(
      itemCount: teamsList.length,
        itemBuilder: (context, index){
          return TeamsCard(teamsList[index]);
        }
    );
  }
}
