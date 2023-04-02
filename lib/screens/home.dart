import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valmob/screens/matchView.dart';
import 'package:valmob/services/matches.dart';
import 'package:valmob/services/players.dart';
import 'package:valmob/services/schedule.dart';
import 'package:valmob/services/teams.dart';
import 'package:valmob/shared/loading.dart';
import 'package:valmob/test/test.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
                "vAlMOB",
                style: TextStyle(
                    fontFamily: 'ValFont',
                  fontSize: 25,
                ),
              ),
        ),
        backgroundColor: Color(0xFF7C0000),
        elevation: 0,
      ),
      body: Text("Nothing"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: (){
          Matches().updateDatabase();
          Teams().updateDatabase();
          Players().updateDatabase();
        },
      ),
    );
  }
}
