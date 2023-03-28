import 'package:flutter/material.dart';
import 'package:valmob/models/match.dart';
import 'package:provider/provider.dart';
import 'package:valmob/screens/matchCard.dart';

class MatchList extends StatefulWidget {
  const MatchList({Key? key}) : super(key: key);

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  @override
  Widget build(BuildContext context) {
    final List<Match> matches = Provider.of<List<Match>>(context);

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index){
        return MatchCard(m: matches[index]);
      }
    );
  }
}
