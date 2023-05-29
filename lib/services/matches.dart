import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valmob/models/matches.dart' as model;
import 'package:intl/intl.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'api.dart';

class Matches{
  final CollectionReference ref = FirebaseFirestore.instance.collection('Matches');
  Future<List<model.Match>> fetchAPI() async{
    print("Fetching Matches API...");
    List<model.Match> matchList = [];
    var url = API().upcomingMatchesAPI;
    var headers = {
      "cache-control": "no-cache",
      "pragma":'no_cache',
      'sec-ch-ua': '"Microsoft Edge";v="111", "Not(A:Brand";v="8", "Chromium";v="111"',
      'sec-ch-ua-platform': "Windows",
      'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 Edg/111.0.1661.62'
    };
    var response = await http.get(url, headers: headers);
    var json2 = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
    
    for(var i = 0; i< json2['data']['segments'].length ; i++){
        matchList.add(
            model.Match(
                team_one_name: json2['data']['segments'][i]['team1'],
                team_two_name: json2['data']['segments'][i]['team2'],
                match_url: json2['data']['segments'][i]['match_page'],
                event_name: json2['data']['segments'][i]['tournament_name'],
                event_icon_url: json2['data']['segments'][i]['tournament_icon'],
                match_time: json2['data']['segments'][i]['time_until_match'] == "Upcoming" ?
                            DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour+1).toString()
                                :
                            json2['data']['segments'][i]['time_until_match'] == "LIVE" ? DateTime.now().toString()
                                :
                            calculateDateTime(json2['data']['segments'][i]['time_until_match']).toString(),
                eta: json2['data']['segments'][i]['time_until_match'],
                flag1: json2['data']['segments'][i]['flag1'],
                flag2: json2['data']['segments'][i]['flag2'],
                score1: json2['data']['segments'][i]['score1'],
                score2: json2['data']['segments'][i]['score2'],
                round_info: json2['data']['segments'][i]['round_info'],
            )
        );
    }
    print("Matches API Fetched. Length: "+matchList.length.toString());
    return matchList;
  }

  void updateDatabase() async{
    List<model.Match> matchList = await fetchAPI();
    print("Updating Matches Database...");
    for(var i = 0; i < matchList.length; i++){
      model.Match current = matchList[i];
      await ref.doc((i+1).toString()).set(
        {
          'team_one_name': current.team_one_name,
          'team_two_name': current.team_two_name,
          'match_url': current.match_url,
          'event_name': current.event_name,
          'event_icon_url': current.event_icon_url,
          'match_time': DateTime.parse(current.match_time),
          'eta': current.eta,
          'flag1': current.flag1,
          'flag2': current.flag2,
          'score1': current.score1,
          'score2': current.score2,
          'round_info': current.round_info,
        }
      );
    }
    print("Updated Matches Database.");
  }

  DateTime calculateDateTime(String eta){
    DateTime dateTime = DateTime.now();
    List<String> strings = eta.split(' ');
    strings.removeAt(strings.length - 1);
    strings.removeAt(strings.length - 1);
    dateTime = dateTime.add(calculateFromEta(strings));
    dateTime = DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch - (dateTime.millisecondsSinceEpoch % Duration(minutes: 5).inMilliseconds));
    return alignDateTime(dateTime, Duration(hours: 1), true);
  }

  Duration calculateFromEta(List<String> times){
    Duration dt = Duration(days: 0);
    times.forEach((element) {
      if(element.endsWith('w')){
        dt = Duration(milliseconds: (dt.inMilliseconds + Duration(days: int.parse(element.substring(0, element.length - 1)) * 7).inMilliseconds));
      }
      else if(element.endsWith('d')){
        dt = Duration(milliseconds: dt.inMilliseconds + Duration(days: int.parse(element.substring(0, element.length - 1))).inMilliseconds);
      }
      else if(element.endsWith('h')){
        dt = Duration(milliseconds: dt.inMilliseconds + Duration(hours: int.parse(element.substring(0, element.length - 1))).inMilliseconds);
      }
      else if(element.endsWith('m')){
        dt = Duration(milliseconds: dt.inMilliseconds + Duration(minutes: int.parse(element.substring(0, element.length - 1))).inMilliseconds);
      }
    });
    return dt;
  }

  DateTime alignDateTime(DateTime dt, Duration alignment,[bool roundUp = false]) {
    assert(alignment >= Duration.zero);
    if (alignment == Duration.zero) return dt;
    final correction = Duration(
        days: 0,
        hours: alignment.inDays > 0
            ? dt.hour
            : alignment.inHours > 0
            ? dt.hour % alignment.inHours
            : 0,
        minutes: alignment.inHours > 0
            ? dt.minute
            : alignment.inMinutes > 0
            ? dt.minute % alignment.inMinutes
            : 0,
        seconds: alignment.inMinutes > 0
            ? dt.second
            : alignment.inSeconds > 0
            ? dt.second % alignment.inSeconds
            : 0,
        milliseconds: alignment.inSeconds > 0
            ? dt.millisecond
            : alignment.inMilliseconds > 0
            ? dt.millisecond % alignment.inMilliseconds
            : 0,
        microseconds: alignment.inMilliseconds > 0 ? dt.microsecond : 0);
    if (correction == Duration.zero) return dt;
    final corrected = dt.subtract(correction);
    final result = roundUp ? corrected.add(alignment) : corrected;
    return result;
  }

  List<model.Match> convertToMatchObject(QuerySnapshot s){
    return s.docs.map((e){
      return model.Match(
          team_one_name: e.get('team_one_name'),
          team_two_name: e.get('team_two_name'),
          match_url: e.get('match_url'),
          event_name: e.get('event_name'),
          event_icon_url: e.get('event_icon_url'),
          match_time: e.get('match_time').toDate().toString(),
          eta: e.get('eta'),
          flag1: e.get('flag1'),
          flag2: e.get('flag2'),
          score1: e.get('score1'),
          score2: e.get('score2'),
          round_info: e.get('round_info'),
      );
    }).toList();
  }

  Stream<List<model.Match>> get getMatch{
    return ref.orderBy('match_time',descending: false).snapshots().map(convertToMatchObject);
  }


  Future<List<String>> getMatchPlayers(url) async{
    var response = await http.get(Uri.parse(url));
    var document = parser.parse(response.body);
    List<Element> elems = document.getElementsByClassName("wf-table-inset mod-overview");
    List<Element> team1 = elems[0].children[1].children;
    List<Element> team2 = elems[1].children[1].children;
    String team1Players = "";
    String team2Players = "";
    team1.forEach((element) {
      team1Players += element.children[0].children[0].children[1].children[1].text.trim() + " " + element.children[0].children[0].children[1].children[0].text.trim() + ",";
    });
    team2.forEach((element) {
      team2Players += element.children[0].children[0].children[1].children[1].text.trim() + " " + element.children[0].children[0].children[1].children[0].text.trim() + ',';
    });
    return [team1Players, team2Players];
  }
}