import 'package:flutter/material.dart';
import 'package:valmob/models/match.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'dart:core';
import 'package:intl/intl.dart';

class MatchCard extends StatelessWidget {
  final Match m;
  const MatchCard({required this.m});

  @override
  Widget build(BuildContext context) {
    String startTime = DateFormat('jms').format(DateTime.parse(m.startTime).add(Duration(hours: 6)));
    String startDate = DateFormat.yMMMd().format(DateTime.parse(m.startTime));
    return CustomCard(
      color: Color(0xFF2A2A2A),
      elevation: 3,
      borderRadius: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            m.league_name,
            style: TextStyle(
                color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.network(
                      m.team1_image,
                      width: 45,
                    ),
                    Text(
                      m.team1_code,
                      style: TextStyle(
                          color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                    "V/S",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Column(
                  children: [
                    Image.network(
                      m.team2_image,
                      width: 45,
                    ),
                    Text(
                      m.team2_code,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            startDate+" "+startTime,
            style: TextStyle(
              color: Colors.white
            ),
          )
    ]
      ),
    );
//    return Text(m.startTime.toString()+" "+m.team1_code+" V/S "+m.team2_code);
  }
}
