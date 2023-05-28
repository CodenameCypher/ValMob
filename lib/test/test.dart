import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

class Test{
  void test() async{
    String eta = '6d 3h from now';
    List<String> splited = eta.split(' ');
    splited.removeAt(splited.length - 1);
    splited.removeAt(splited.length - 1);
    print(splited);
    print(DateTime.now().add(calculateFromEta(splited)));
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

  Future<Map<String, dynamic>> scrapeSite(url) async{
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
    List<dom.Element> lst = document.getElementsByClassName("wf-card mod-dark match-streams-btn").where((element) => element.attributes.containsKey('href')).toList() + document.getElementsByClassName("match-streams-btn-external").where((element) => element.attributes.containsKey('href')).toList();
    List<String> streams = [];
    for(int i = 0; i < lst.length; i++){
      streams.add(lst[i].attributes['href']!);
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

    List<String> team1Players = [];
    List<String> team2Players = [];
    List<List<String>> team1Stats = [];
    List<List<String>> team2Stats = [];

    try{
      List<dom.Element> elems = document.getElementsByClassName("vm-stats-game").where((element) => element.attributes['data-game-id'] == 'all').toList();
      List<dom.Element> team1 = elems[0].children[1].children[0].children[0].children[1].children;
      List<dom.Element> team2 = elems[0].children[1].children[1].children[0].children[1].children;

      team1.forEach((element) {
        team1Players.add(element.children[0].children[0].children[1].children[1].text.trim() + " " + element.children[0].children[0].children[1].children[0].text.trim());
        var kills = element.children[4].children[0].children[0].text.trim();
        var deaths = element.children[5].children[0].children[1].children[0].text.trim();
        var assists = element.children[6].children[0].children[0].text.trim();
        var kast = element.children[8].children[0].children[0].text.trim();
        var ADR = element.children[9].children[0].children[0].text.trim();
        var HS = element.children[10].children[0].children[0].text.trim();
        var ACS = element.children[3].children[0].children[0].text.trim();
        team1Stats.add([ACS, kills, deaths, assists, kast, ADR, HS]);
      });
      team2.forEach((element) {
        team2Players.add(element.children[0].children[0].children[1].children[1].text.trim() + " " + element.children[0].children[0].children[1].children[0].text.trim());
        var kills = element.children[4].children[0].children[0].text.trim();
        var deaths = element.children[5].children[0].children[1].children[0].text.trim();
        var assists = element.children[6].children[0].children[0].text.trim();
        var kast = element.children[8].children[0].children[0].text.trim();
        var ADR = element.children[9].children[0].children[0].text.trim();
        var HS = element.children[10].children[0].children[0].text.trim();
        var ACS = element.children[3].children[0].children[0].text.trim();
        team2Stats.add([ACS, kills, deaths, assists, kast, ADR, HS]);
      });
    }catch(e){
      List<dom.Element> elems = document.getElementsByClassName("vm-stats-game").where((element) => element.attributes['data-game-id'] == 'all').toList();
      List<dom.Element> team1 = elems[0].children[0].children[0].children[0].children[1].children;
      List<dom.Element> team2 = elems[0].children[0].children[1].children[0].children[1].children;


      team1.forEach((element) {
        team1Players.add(element.children[0].children[0].children[1].children[1].text.trim() + " " + element.children[0].children[0].children[1].children[0].text.trim());
        var kills = element.children[4].children[0].children[0].text.trim();
        var deaths = element.children[5].children[0].children[1].children[0].text.trim();
        var assists = element.children[6].children[0].children[0].text.trim();
        var kast = element.children[8].children[0].children[0].text.trim();
        var ADR = element.children[9].children[0].children[0].text.trim();
        var HS = element.children[10].children[0].children[0].text.trim();
        var ACS = element.children[3].children[0].children[0].text.trim();
        team1Stats.add([ACS, kills, deaths, assists, kast, ADR, HS]);
      });
      team2.forEach((element) {
        team1Players.add(element.children[0].children[0].children[1].children[1].text.trim() + " " + element.children[0].children[0].children[1].children[0].text.trim());
        var kills = element.children[4].children[0].children[0].text.trim();
        var deaths = element.children[5].children[0].children[1].children[0].text.trim();
        var assists = element.children[6].children[0].children[0].text.trim();
        var kast = element.children[8].children[0].children[0].text.trim();
        var ADR = element.children[9].children[0].children[0].text.trim();
        var HS = element.children[10].children[0].children[0].text.trim();
        var ACS = element.children[3].children[0].children[0].text.trim();
        team2Stats.add([ACS, kills, deaths, assists, kast, ADR, HS]);
      });
    }
    String maps = "";
    try{
      maps = document.getElementsByClassName("match-header-note")[0].text.trim();
    }catch(e){
      maps = "---";
    }
    Map<String, dynamic> results = {
      'DateTime' : DateTime(DateTime.now().year, dt.month, dt.day, dt.hour, dt.minute).toString(),
      'logo1' : logo1.toString(),
      'logo2' : logo2.toString(),
      'streams' : streams,
      'team_one_players' : team1Players,
      'team_two_players' : team2Players,
      'maps': maps,
      'team1Stats' : team1Stats,
      'team2Stats' : team2Stats
    };
    return results;
  }
}