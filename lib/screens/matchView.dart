import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/models/match.dart';
import 'package:valmob/screens/matchListView.dart';
import 'package:valmob/services/schedule.dart';

class MatchView extends StatelessWidget {
  const MatchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Match>>.value(
        value: Schedule().getMatches,
        initialData: [],
        child: MatchList(),
    );
  }
}
