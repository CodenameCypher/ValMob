import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valmob/models/player.dart';

class Players{
  final CollectionReference ref = FirebaseFirestore.instance.collection("Players");
  Future<List<Player>> fetchAPI() async{
    print("Fetching Players API...");
    final url = Uri.parse("https://vlrgg.cyclic.app/api/players");
    var response = await http.get(url);
    var json = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
    List<Player> playerList = [];
    for(var i=0; i < json['players'].length ; i++){
      var current = json['players'][i];
      playerList.add(Player(
          player_name: current['player_name'],
          player_link: current['player_link'],
          player_team_initials: current['player_team_initials'],
          player_country_initials: current['player_country_initials'],
          rounds_played: current['rounds_played'],
          rating: current['rating'],
          average_combat_score: current['average_combat_score'],
          kills_deaths: current['kills_deaths'],
          kill_assist_trade_survive_percentage: current['kill_assist_trade_survive_percentage'],
          average_damage_per_round: current['average_damage_per_round'],
          kills_per_round: current['kills_per_round'],
          assists_per_round: current['assists_per_round'],
          first_kills_per_round: current['first_kills_per_round'],
          first_deaths_per_round: current['first_deaths_per_round'],
          headshot_percentage: current['headshot_percentage'],
          clutch_success_percentage: current['clutch_success_percentage'],
          max_kills_in_single_map: current['max_kills_in_single_map'],
          kills: current['kills'],
          deaths: current['deaths'])
      );
    }
    print("Players API Fetched.");
    return playerList;
  }

  void updateDatabase() async{
    List<Player> playerList = await fetchAPI();
    print("Updating Players Database...");
    for(var i=0; i < playerList.length ; i++){
      var current = playerList[i];
      await ref.doc(current.player_name).set({
          'player_name': current.player_name,
          'player_link': current.player_link,
          'player_team_initials': current.player_team_initials,
          'player_country_initials': current.player_country_initials,
          'rounds_played': current.rounds_played,
          'rating': current.rating,
          'average_combat_score': current.average_combat_score,
          'kills_deaths': current.kills_deaths,
          'kill_assist_trade_survive_percentage': current.kill_assist_trade_survive_percentage,
          'average_damage_per_round': current.average_damage_per_round,
          'kills_per_round': current.kills_per_round,
          'assists_per_round': current.assists_per_round,
          'first_kills_per_round': current.first_kills_per_round,
          'first_deaths_per_round': current.first_deaths_per_round,
          'headshot_percentage': current.headshot_percentage,
          'clutch_success_percentage': current.clutch_success_percentage,
          'max_kills_in_single_map': current.max_kills_in_single_map,
          'kills': current.kills,
          'deaths': current.deaths
      });
    }
    print('Updated Players Database.');
  }
}