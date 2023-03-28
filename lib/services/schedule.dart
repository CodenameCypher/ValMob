import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valmob/models/match.dart';

class Schedule{
  CollectionReference ref = FirebaseFirestore.instance.collection('matches');
  Future<List<Match>> fetchAPI() async{
    final url = Uri.parse("https://valorant-esports.p.rapidapi.com/schedule");
    var headers = {"X-RapidAPI-Key": "5922d83798msh327ff1179b7a77fp1b4486jsnfdb138ba815c",
      "X-RapidAPI-Host": "valorant-esports.p.rapidapi.com"
    };
    var response = await http.get(url, headers: headers);
    var json = jsonDecode(response.body);
    var matches = json['data']['schedule']['events'];
    List<Match> matchList = [];
    print("Api Called");
    for (var i = 0; i < matches.length; i++) {
      var currentElement = matches[i];
      matchList.add(Match(
          startTime: currentElement['startTime'].toString(),
          state: currentElement['state'],
          league_name: currentElement['league']['name'],
          league_image: currentElement['league']['image'],
          league_region: currentElement['league']['region'],
          tournament_name: currentElement['tournament']['split']['name'],
          tournament_season: currentElement['tournament']['season']['name'],
          match_id: currentElement['match']['id'],
          team1_name: currentElement['match']['teams'][0]['name'],
          team1_code: currentElement['match']['teams'][0]['code'],
          team1_image: currentElement['match']['teams'][0]['image'],
          team2_name: currentElement['match']['teams'][1]['name'],
          team2_code: currentElement['match']['teams'][1]['code'],
          team2_image: currentElement['match']['teams'][1]['image'],
          strategy_type: currentElement['match']['strategy']['type'],
          strategy_count: currentElement['match']['strategy']['count'].toString()
      ));
    }
    print('API Fetched!');
    return matchList;
  }
  void updateDatabase() async{
    List<Match> matches = await fetchAPI();
    for (var i = 0; i < matches.length; i++) {
      var match = matches[i];
      await ref.doc(match.match_id).set({
        'startTime': match.startTime,
        'state': match.state,
        'league_name': match.league_name,
        'league_image': match.league_image,
        'league_region': match.league_region,
        'tournament_name': match.tournament_name,
        'tournament_season': match.tournament_season,
        'match_id': match.match_id,
        'team1_name': match.team1_name,
        'team1_code': match.team1_code,
        'team1_image': match.team1_image,
        'team2_name': match.team2_name,
        'team2_code': match.team2_code,
        'team2_image': match.team2_image,
        'strategy_type': match.strategy_type,
        'strategy_count': match.strategy_count
      });
    }
    print('Database updated!');
  }

  List<Match> convertToMatchObject(QuerySnapshot s){
    return s.docs.map((e){
      Match match = Match(
          startTime: e.get('startTime'),
          state: e.get('state'),
          league_name: e.get('league_name'),
          league_image: e.get('league_image'),
          league_region: e.get('league_region'),
          tournament_name: e.get('tournament_name'),
          tournament_season: e.get('tournament_season'),
          match_id: e.get('match_id'),
          team1_name: e.get('team1_name'),
          team1_code: e.get('team1_code'),
          team1_image: e.get('team1_image'),
          team2_name: e.get('team2_name'),
          team2_code: e.get('team2_code'),
          team2_image: e.get('team2_image'),
          strategy_type: e.get('strategy_type'),
          strategy_count: e.get('strategy_count')
      );
      return match;
    }).toList();
  }

  Stream<List<Match>> get getMatches{
    return ref.orderBy("startTime",descending: false).snapshots().map(convertToMatchObject);
  }
}