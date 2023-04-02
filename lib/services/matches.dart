import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valmob/models/matches.dart';
import 'package:intl/intl.dart';

class Matches{
  final CollectionReference ref = FirebaseFirestore.instance.collection('Matches');
  Future<List<Match>> fetchAPI() async{
    print("Fetching Matches API...");
    List<Match> matchList = [];
    var url1 = Uri.parse("https://vlrgg.cyclic.app/api/matches/upcoming");
    var url2 = Uri.parse("https://vlrggapi.vercel.app/match/upcoming");
    var response1 = await http.get(url1);
    var response2 = await http.get(url2);
    var json1 = jsonDecode(response1.body);
    var json2 = jsonDecode(response2.body);
    for(var i = 0; i< json1['matches'].length ; i++){
        matchList.add(
            Match(
                team_one_name: json1['matches'][i]['team_one_name'],
                team_two_name: json1['matches'][i]['team_two_name'],
                match_url: json1['matches'][i]['match_url'],
                event_name: json1['matches'][i]['event_name'],
                event_icon_url: json1['matches'][i]['event_icon_url'],
                match_time: json1['matches'][i]['match_time'],
                eta: json1['matches'][i]['eta'],
                flag1: json2['data']['segments'][i]['flag1'],
                flag2: json2['data']['segments'][i]['flag2'],
                score1: json2['data']['segments'][i]['score1'],
                score2: json2['data']['segments'][i]['score2'],
                round_info: json2['data']['segments'][i]['round_info']
            )
        );
    }
    print("Matches API Fetched. Length: "+matchList.length.toString());
    return matchList;
  }

  void updateDatabase() async{
    List<Match> matchList = await fetchAPI();
    print("Updating Matches Database...");
    for(var i = 0; i < matchList.length; i++){
      Match current = matchList[i];
      DateTime date = current.eta == ""? DateTime.now() : calculateDateTime(current.eta);
      await ref.doc((i+1).toString()).set(
        {
          'team_one_name': current.team_one_name,
          'team_two_name': current.team_two_name,
          'match_url': current.match_url,
          'event_name': current.event_name,
          'event_icon_url': current.event_icon_url,
          'match_date': DateFormat("yyyy-MM-dd hh:mm a","en-us").parse(date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString()+" "+current.match_time),
          'eta': current.eta,
          'flag1': current.flag1,
          'flag2': current.flag2,
          'score1': current.score1,
          'score2': current.score2,
          'round_info': current.round_info
        }
      );
    }
    print("Updated Matches Database.");
  }

  DateTime calculateDateTime(String eta){
    DateTime dateTime = DateTime.now();
    List<String> strings = eta.split(" ");
    for(var i = 0; i < strings.length ; i++){
      String current = strings[i];
      if(current[current.length-1] == 'd'){
        dateTime = dateTime.add(Duration(days: int.parse(current.substring(0,current.length-1))));
      }
      else if(current[current.length-1] == 'h'){
        dateTime = dateTime.add(Duration(hours: int.parse(current.substring(0,current.length-1))));
      }else{
        dateTime = dateTime.add(Duration(minutes: int.parse(current.substring(0,current.length-1))));
      }
    }
    return dateTime;
  }
}