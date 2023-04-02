import 'package:flutter/material.dart';
import 'package:valmob/models/match.dart';
import 'package:provider/provider.dart';
import 'package:valmob/screens/matchCard.dart';
import 'package:valmob/shared/loading.dart';
import 'package:calendar_agenda/calendar_agenda.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CalendarAgenda(
          backgroundColor: Color(0xFF7C0000),
          appbar: false,
          firstDate: DateTime.parse(matches[0].startTime),
          initialDate: DateTime.now(),
          lastDate: DateTime.parse(matches[matches.length-1].startTime),
          onDateSelected: (value){
            setState(() {
              today = value;
            });
          },
          fullCalendar: false,
        ),
      ),
      backgroundColor: Color(0xFF420000),
      body: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index){
            return DateTime.parse(matches[index].startTime).day != today.day ? SizedBox(width: 0,) : MatchCard(m: matches[index]);
          }
      ),
    );
  }
}
