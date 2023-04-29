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
      var json = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
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
    print("Teams API Fetched. Length: "+teamList.length.toString());
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

  Future<List<Team>> getTeam(String teamName1, String teamName2) async{
    DocumentSnapshot doc1 =  await this.ref.doc(teamName1).get();
    DocumentSnapshot doc2 =  await this.ref.doc(teamName2).get();
    Team team1 = Team(
        region: doc1.get('region'),
        rank: doc1.get('rank'),
        team: doc1.get('team'),
        country: doc1.get('country'),
        last_played: doc1.get('last_played'),
        last_played_team: doc1.get('last_played_team'),
        last_played_team_logo: doc1.get('last_played_team_logo'),
        record: doc1.get('record'),
        earnings: doc1.get('earnings'),
        logo: doc1.get('logo')
    );
    Team team2 = Team(
        region: doc2.get('region'),
        rank: doc2.get('rank'),
        team: doc2.get('team'),
        country: doc2.get('country'),
        last_played: doc2.get('last_played'),
        last_played_team: doc2.get('last_played_team'),
        last_played_team_logo: doc2.get('last_played_team_logo'),
        record: doc2.get('record'),
        earnings: doc2.get('earnings'),
        logo: doc2.get('logo')
    );
    return [team1, team2];
  }

  List<Team> convertToTeamObject(QuerySnapshot s){
    return s.docs.map((e){
      return Team(
          region: e.get('region'),
          rank: e.get('rank'),
          team: e.get('team'),
          country: e.get('country'),
          last_played: e.get('last_played'),
          last_played_team: e.get('last_played_team'),
          last_played_team_logo: e.get('last_played_team_logo'),
          record: e.get('record'),
          earnings: e.get('earnings'),
          logo: e.get('logo')
      );
    }).toList();
  }

  Stream<List<Team>> get getTeamStream{
    return ref.snapshots().map(convertToTeamObject);
  }
}