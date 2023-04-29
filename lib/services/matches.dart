import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valmob/models/matches.dart' as model;
import 'package:intl/intl.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

class Matches{
  final CollectionReference ref = FirebaseFirestore.instance.collection('Matches');
  Future<List<model.Match>> fetchAPI() async{
    print("Fetching Matches API...");
    List<model.Match> matchList = [];
    var url = Uri.parse("https://vlrggapi.vercel.app/match/upcoming");
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
      Map<String, String> extraInformation;
      if(json2['data']['segments'][i]['time_until_match'] == "LIVE" || json2['data']['segments'][i]['time_until_match'] == "Upcoming"){
        extraInformation = await scrapeSite("https://vlr.gg"+json2['data']['segments'][i]['match_page']);
      }else{
        extraInformation = {
          'DateTime' : json2['data']['segments'][i]['time_until_match'] == "Upcoming" ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour+1).toString() : calculateDateTime(json2['data']['segments'][i]['time_until_match']).toString(),
          'logo1' : "",
          'logo2' : "",
          'streams' : "",
          'team_one_players' : "-",
          'team_two_players' : "-"
        };
      }
        matchList.add(
            model.Match(
                team_one_name: json2['data']['segments'][i]['team1'],
                team_two_name: json2['data']['segments'][i]['team2'],
                team_one_players: extraInformation['team_one_players']!,
                team_two_players: extraInformation['team_two_players']!,
                team_one_logo: extraInformation['logo1']!,
                team_two_logo: extraInformation['logo2']!,
                match_url: json2['data']['segments'][i]['match_page'],
                event_name: json2['data']['segments'][i]['tournament_name'],
                event_icon_url: json2['data']['segments'][i]['tournament_icon'],
                match_time: extraInformation['DateTime']!,
                eta: json2['data']['segments'][i]['time_until_match'],
                flag1: json2['data']['segments'][i]['flag1'],
                flag2: json2['data']['segments'][i]['flag2'],
                score1: json2['data']['segments'][i]['score1'],
                score2: json2['data']['segments'][i]['score2'],
                round_info: json2['data']['segments'][i]['round_info'],
                streams: extraInformation['streams']!
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
          'team_one_players': current.team_one_players,
          'team_two_players': current.team_two_players,
          'team_one_logo' : current.team_one_logo,
          'team_two_logo' : current.team_two_logo,
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
          'streams' : current.streams
        }
      );
    }
    print("Updated Matches Database.");
  }

  DateTime calculateDateTime(String eta){
    DateTime dateTime = DateTime.now();
    List<String> strings = eta.split(" ");
    for(var i = 0; i < strings.length - 2 ; i++){
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
    dateTime = DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch - (dateTime.millisecondsSinceEpoch % Duration(minutes: 5).inMilliseconds));
    return alignDateTime(dateTime, Duration(hours: 1), true);
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
          team_one_players: e.get('team_one_players'),
          team_two_players: e.get('team_two_players'),
          team_one_logo: e.get('team_one_logo'),
          team_two_logo: e.get('team_two_logo'),
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
          streams: e.get('streams')
      );
    }).toList();
  }

  Stream<List<model.Match>> get getMatch{
    return ref.orderBy('match_time',descending: false).snapshots().map(convertToMatchObject);
  }
  Future<Map<String, String>> scrapeSite(url) async{
    var urlScraping = Uri.parse(url);
    var responseHTML = await http.get(urlScraping);
    var document = parser.parse(responseHTML.body);

    var dateTime = document.getElementsByClassName('moment-tz-convert');
    var dateTimeString = '';
    for(int i = 0; i < dateTime.length; i++){
      dateTimeString += dateTime[i].text.trim() + " ";
    }
    var logo1 = document.getElementsByClassName('match-header-link wf-link-hover mod-1')[0].getElementsByTagName('img')[0].attributes['src'];
    var logo2 = document.getElementsByClassName('match-header-link wf-link-hover mod-2')[0].getElementsByTagName('img')[0].attributes['src'];

    List<Element> lst = document.getElementsByClassName("wf-card mod-dark match-streams-btn").where((element) => element.attributes.containsKey('href')).toList() + document.getElementsByClassName("match-streams-btn-external").where((element) => element.attributes.containsKey('href')).toList();
    String streams = "";
    for(int i = 0; i < lst.length; i++){
      streams += lst[i].attributes['href']! + " ";
    }

    DateTime dt;
    try{
      dt = DateFormat("EEEE, MMMM dd'th' hh:mm aa ZZ").parse(dateTimeString);
    }catch(e){
      try{
        dt = DateFormat("EEEE, MMMM dd'st' hh:mm aa ZZ").parse(dateTimeString);
      }catch(e){
        dt = DateFormat("EEEE, MMMM dd'rd' hh:mm aa ZZ").parse(dateTimeString);
      }
    }

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

    Map<String, String> results = {
      'DateTime' : DateTime(DateTime.now().year, dt.month, dt.day, dt.hour, dt.minute).toString(),
      'logo1' : logo1.toString(),
      'logo2' : logo2.toString(),
      'streams' : streams,
      'team_one_players' : team1Players,
      'team_two_players' : team2Players
    };
    return results;
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