import 'package:flutter/material.dart';
import 'package:valmob/models/match.dart';
import 'package:provider/provider.dart';
import 'package:valmob/screens/matchCard.dart';
import 'package:valmob/shared/loading.dart';

class MatchList extends StatefulWidget {
  const MatchList({Key? key}) : super(key: key);

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final List<Match> matches = Provider.of<List<Match>>(context);
    return matches.length == 0 ? Loading() : Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      body: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index){
            return DateTime.parse(matches[index].startTime).day != today.day ? SizedBox(width: 0,) : MatchCard(m: matches[index]);
          }
      ),
    );
  }
}
