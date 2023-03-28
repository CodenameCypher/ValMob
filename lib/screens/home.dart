import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valmob/screens/matchView.dart';
import 'package:valmob/services/schedule.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        title: Text(
              "vAlmob",
              style: TextStyle(
                  fontFamily: 'ValFont'
              ),
            ),
        backgroundColor: Color(0xFF7C0000),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          )
        ),
      ),
      body: MatchView(),
      floatingActionButton: FloatingActionButton(
        onPressed: Schedule().updateDatabase,
      ),
    );
  }
}
