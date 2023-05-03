import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

class Test{
  void test() async{
    var response = await http.get(Uri.parse("https://www.vlr.gg/204757/moist-moguls-guild-x-kone-news-almost-missed-april-29"));
    var document = parser.parse(response.body);
    Element elem = document.getElementsByClassName('article-body')[0];
    List<Element> elemsRemove = elem.getElementsByClassName('wf-hover-card');
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

    Map<String, String> results = {
      'DateTime' : dt.toString(),
      'logo1' : logo1.toString(),
      'logo2' : logo2.toString(),
      'streams' : streams
    };
    return results;
  }
}