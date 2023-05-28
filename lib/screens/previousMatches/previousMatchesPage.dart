import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valmob/models/matches.dart' as model;
import 'package:valmob/shared/loading.dart';
import 'package:valmob/shared/theme.dart' as shared;
import '../../models/team.dart';
import '../../services/flags.dart';
import '../../services/teams.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class PreviousMatchesPage extends StatefulWidget {
  model.Match m;
  PreviousMatchesPage({required this.m});

  @override
  State<PreviousMatchesPage> createState() => _PreviousMatchesPageState();
}

class _PreviousMatchesPageState extends State<PreviousMatchesPage> {
  Map<String, dynamic> extraInfo = {};
  bool isLoading = true;
  List<List<String>> streamLinks = [];
  List<String> team1Players = ["-","-","-","-","-"];
  List<String> team2Players = ["-","-","-","-","-"];

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
    List<dom.Element> lst = document.getElementsByClassName("match-vods")[0]
        .children.where((element) => element.className == 'match-streams-container').toList()[0]
        .children.where((element) => element.attributes.containsKey('href')).toList();
    List<List<String>> streams = [];
    for(int i = 0; i < lst.length; i++){
      List<String> temp = [lst[i].text.trim().toString(),lst[i].attributes['href']!.toString()];
      streams.add(temp);
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

  @override
  Widget build(BuildContext context) {
    this.scrapeSite("https://vlr.gg" + widget.m.match_url).then((value) {
      setState(() {
        extraInfo = value;
        streamLinks = extraInfo['streams'];
        team1Players = extraInfo['team_one_players'];
        team2Players = extraInfo['team_two_players'];
        isLoading = false;
      });
    });

    return Scaffold(
        backgroundColor: shared.Theme.swatch1,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20)
              )
          ),
          centerTitle: true,
          title: Text(
            "vAlMOB",
            style: TextStyle(
              fontFamily: 'ValFont',
              fontSize: 25,
            ),
          ),
          backgroundColor: shared.Theme.swatch2,
          elevation: 0,
        ),
        body: isLoading ? Loading() : Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: shared.Theme.swatch1,
                padding: EdgeInsets.fromLTRB(0,10,0,0),
                child: ListTile(
                  isThreeLine: false,
                  title: Column(
                    children: [
                      Text(
                        this.widget.m.event_name,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10
                        ),
                      ),
                      FutureBuilder(
                        future: Teams().getTeam(this.widget.m.team_one_name, this.widget.m.team_two_name),
                        builder: (context, t){
                          List<Team>? snapshot = t.data;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: shared.Theme.swatch2,
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 7),
                                          child: extraInfo['logo1'] == "/img/vlr/tmp/vlr.png" ?
                                          Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 40,width: 40)
                                              :
                                          Image.network("https:"+extraInfo['logo1']!, height: 40, width: 40,)
                                      ),
                                      this.widget.m.team_one_name.split(" ").length == 1 ? Text(
                                        this.widget.m.team_one_name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            letterSpacing: 1,
                                            fontFamily: "Font4"
                                        ),
                                      ) : SizedBox(
                                        height: 20,
                                        width: 70,
                                        child: Marquee(
                                          text: this.widget.m.team_one_name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              letterSpacing: 1,
                                              fontFamily: "Font4"
                                          ),
                                          scrollAxis: Axis.horizontal,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          blankSpace: 10.0,
                                          velocity: 40.0,
                                          accelerationDuration: Duration(seconds: 1),
                                          accelerationCurve: Curves.linear,
                                          decelerationDuration: Duration(milliseconds: 500),
                                          decelerationCurve: Curves.easeOut,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 13,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                Flag().getLink(this.widget.m.flag1),
                                                width: 12,
                                              ),
                                              Text(
                                                " " + Flag().getName(this.widget.m.flag1),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 8.5
                                                ),
                                              )
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    // color: Colors.red,
                                      child: CircleAvatar(
                                        child: Stack(
                                          children: [
                                            Opacity(
                                              opacity: 0.2,
                                              child: Image.network(
                                                this.widget.m.event_icon_url,
                                                height: 40,
                                              ),
                                            ),
                                            Text(
                                              'V/S',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Font3',
                                              ),
                                            )
                                          ],
                                          alignment: Alignment.center,
                                        ),
                                        backgroundColor: shared.Theme.swatch1Light,
                                      )
                                  )
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: shared.Theme.swatch2,
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(bottom: 7),
                                            child: extraInfo['logo2'] == "/img/vlr/tmp/vlr.png" ?
                                            Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 40,width: 40)
                                                :
                                            Image.network("https:"+extraInfo['logo2']!, height: 40, width: 40,)
                                        ),
                                        this.widget.m.team_two_name.split(" ").length == 1 ? Text(
                                          this.widget.m.team_two_name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              letterSpacing: 1,
                                              fontFamily: "Font4"
                                          ),
                                        ) : SizedBox(
                                          height: 20,
                                          width: 70,
                                          child: Marquee(
                                            text: this.widget.m.team_two_name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                letterSpacing: 1,
                                                fontFamily: "Font4"
                                            ),
                                            scrollAxis: Axis.horizontal,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            blankSpace: 10.0,
                                            velocity: 40.0,
                                            accelerationDuration: Duration(seconds: 1),
                                            accelerationCurve: Curves.linear,
                                            decelerationDuration: Duration(milliseconds: 500),
                                            decelerationCurve: Curves.easeOut,
                                          ),
                                        ),
                                        SizedBox(
                                            height: 13,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                  Flag().getLink(this.widget.m.flag2),
                                                  width: 12,
                                                ),
                                                Text(
                                                  " " + Flag().getName(this.widget.m.flag2),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 8.5
                                                  ),
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    ),
                                  )
                              )
                            ],
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              this.widget.m.score1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              DateFormat("MMM d, h:mm a").format(DateTime.parse(extraInfo['DateTime']!)).toString() + "\n" + this.widget.m.eta,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13
                              ),
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              this.widget.m.score2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          extraInfo['maps']! == '---' ? "Maps: Maps not decided yet" : "Maps: " + extraInfo['maps']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontStyle: extraInfo['maps']! == '---' ? FontStyle.italic : FontStyle.normal,
                              height: 2
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () async{

                  },
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(10),
                    color: shared.Theme.swatch1Lighter
                ),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 25),
                padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Row(
                        children: [
                          Expanded(flex: 4, child: Text(widget.m.team_one_name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("ACS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("K", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("D", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("A", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("ADR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("HS%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.11,
                        child: ListView.builder(
                            itemCount: team1Players.length,
                            itemBuilder: (context, index){
                              return Row(
                                children: [
                                  Expanded(flex: 4, child: Text(team1Players[index], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team1Stats'][index][0] == "" ? '-' : extraInfo['team1Stats'][index][0], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team1Stats'][index][1] == "" ? '-' : extraInfo['team1Stats'][index][1], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team1Stats'][index][2] == "" ? '-' : extraInfo['team1Stats'][index][2], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team1Stats'][index][3] == "" ? '-' : extraInfo['team1Stats'][index][3], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team1Stats'][index][5] == "" ? '-' : extraInfo['team1Stats'][index][5], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team1Stats'][index][6] == "" ? '-' : extraInfo['team1Stats'][index][6], style: TextStyle(color: Colors.white),)),
                                ],
                              );
                            }
                        )
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Row(
                        children: [
                          Expanded(flex: 4, child: Text(widget.m.team_two_name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("ACS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("K", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("D", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("A", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("ADR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Expanded(child: Text("HS%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.11,
                        child: ListView.builder(
                            itemCount: team2Players.length,
                            itemBuilder: (context, index){
                              return Row(
                                children: [
                                  Expanded(flex: 4, child: Text(team2Players[index], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team2Stats'][index][0] == "" ? "-" : extraInfo['team2Stats'][index][0], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team2Stats'][index][1] == "" ? "-" : extraInfo['team2Stats'][index][1], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team2Stats'][index][2] == "" ? "-" : extraInfo['team2Stats'][index][2], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team2Stats'][index][3] == "" ? "-" : extraInfo['team2Stats'][index][3], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team2Stats'][index][5] == "" ? "-" : extraInfo['team2Stats'][index][5], style: TextStyle(color: Colors.white),)),
                                  Expanded(child: Text(extraInfo['team2Stats'][index][6] == "" ? "-" : extraInfo['team2Stats'][index][6], style: TextStyle(color: Colors.white),)),
                                ],
                              );
                            }
                        )
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(10),
                    color: shared.Theme.swatch1Light
                ),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(top: 7),
                          child: Text(
                            "VODs",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                          ),
                        )
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 7),
                        child: ListView.builder(
                            itemCount: streamLinks.length,
                            itemBuilder: (context, index){
                              return streamLinks[index] == "" ? SizedBox(height: 0,) : Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                child: NeumorphicButton(
                                  style: NeumorphicStyle(
                                    color: shared.Theme.swatch1Lighter,
                                    depth: 15,
                                    intensity: 0.5,
                                    shadowLightColor: shared.Theme.swatch1Light,
                                    shadowDarkColor: shared.Theme.swatch1Light,
                                    shape: NeumorphicShape.flat,
                                    lightSource: LightSource.bottom,
                                  ),
                                  child: Text(
                                    streamLinks[index][0].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  onPressed: () async{
                                    await launchUrl(
                                      Uri.parse(streamLinks[index][1]),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                ),
                              );
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
