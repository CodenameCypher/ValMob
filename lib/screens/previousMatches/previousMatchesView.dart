import 'package:flutter/material.dart';
import 'package:valmob/screens/previousMatches/previousMatchesListView.dart';
import 'package:valmob/services/previousMatches.dart';
import 'package:provider/provider.dart';
import 'package:valmob/models/matches.dart' as model;

class PreviousMatchesView extends StatelessWidget {
  const PreviousMatchesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreviousMatches().updateDatabase();
    return StreamProvider<List<model.Match>>.value(
      value: PreviousMatches().getMatch,
      initialData: [],
      child: PreviousMatchesListView(),
    );
  }
}
