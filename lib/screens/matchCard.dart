import 'package:flutter/material.dart';
import 'package:valmob/models/match.dart';

class MatchCard extends StatelessWidget {
  final Match m;
  const MatchCard({required this.m});

  @override
  Widget build(BuildContext context) {
    return Text(m.startTime.toString()+" "+m.team1_code+" V/S "+m.team2_code);
  }
}
