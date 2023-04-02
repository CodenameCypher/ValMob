import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valmob/models/team.dart';

class Teams{
  final CollectionReference ref = FirebaseFirestore.instance.collection("Teams");
  Future<List<Team>> fetchAPI() async{
    List<Team> teamList = [];
    List<String> regions = ['na', 'eu', 'ap', 'la', 'oce', 'kr', 'mn','gc','br','cn','la-s','la-n'];
    print("Fetching Teams API...");
    for(var i = 0; i < regions.length; i++){
      var url = Uri.parse('https://vlrggapi.vercel.app/rankings/'+regions[i]);
      var response = await http.get(url);
      var json = jsonDecode(response.body);
      for(var j = 0; j < json['data'].length; j++){
        var current = json['data'][j];
        teamList.add(
          Team(
              region: regions[i].toUpperCase(),
              rank: current['rank'],
              team: current['team'],
              country: current['country'],
              last_played: current['last_played'],
              last_played_team: current['last_played_team'],
              last_played_team_logo: current['last_played_team_logo'],
              record: current['record'],
              earnings: current['earnings'],
              logo: current['logo'])
        );
      }
    }
    print("Teams API Fetched.");
    return teamList;
  }

  void updateDatabase() async{
    List<Team> teamList = await fetchAPI();
    print("Updating Teams Database...");
    for(var i = 0; i < teamList.length; i++){
      Team current = teamList[i];
      await ref.doc(current.team.replaceAll("/", '')).set({
        'region': current.region,
        'rank': current.rank,
        'team': current.team,
        'country': current.country,
        'last_played': current.last_played,
        'last_played_team': current.last_played_team,
        'last_played_team_logo': current.last_played_team_logo,
        'record': current.record,
        'earnings': current.earnings,
        'logo': current.logo
      });
    }
    print('Updated Teams Database.');
  }
}