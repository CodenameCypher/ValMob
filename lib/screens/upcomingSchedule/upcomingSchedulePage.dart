import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valmob/models/matches.dart' as model;
import 'package:valmob/shared/theme.dart' as shared;
import '../../models/team.dart';
import '../../services/flags.dart';
import '../../services/teams.dart';

class UpcomingSchedulePage extends StatelessWidget {
  model.Match m;
  UpcomingSchedulePage({required this.m});

  @override
  Widget build(BuildContext context) {
    List<String> streamLinks = m.streams.split(" ");
    List<String> team1Players = m.team_one_players.split(",");
    List<String> team2Players = m.team_two_players.split(",");
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
      body: Column(
        children: [
          Container(
            color: shared.Theme.swatch1,
            padding: EdgeInsets.fromLTRB(0,10,0,0),
            child: ListTile(
              isThreeLine: true,
              title: Column(
                children: [
                  Text(
                    this.m.event_name,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    ),
                  ),
                  FutureBuilder(
                    future: Teams().getTeam(this.m.team_one_name, this.m.team_two_name),
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
                                    child: m.eta == "LIVE" ? Image.network("https:" + m.team_one_logo, height: 40, width: 40,) : snapshot != null && snapshot[0] != null && snapshot[0].logo != "" ?
                                    Image.network("https:"+snapshot[0].logo, height: 40, width: 40,)
                                        :
                                    Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 40,width: 40),
                                  ),
                                  this.m.team_one_name.split(" ").length == 1 ? Text(
                                    this.m.team_one_name,
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
                                      text: this.m.team_one_name,
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
                                            Flag().getLink(this.m.flag1),
                                            width: 12,
                                          ),
                                          Text(
                                            " " + Flag().getName(this.m.flag1),
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
                                            this.m.event_icon_url,
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
                                      child: m.eta == "LIVE" ? Image.network("https:" + m.team_two_logo, height: 40, width: 40,) :snapshot != null && snapshot[1] != null && snapshot[1].logo != "" ?
                                      Image.network("https:"+snapshot[1].logo, height: 40,width: 40)
                                          :
                                      Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 40,width: 40),
                                    ),
                                    this.m.team_two_name.split(" ").length == 1 ? Text(
                                      this.m.team_two_name,
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
                                        text: this.m.team_two_name,
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
                                              Flag().getLink(this.m.flag2),
                                              width: 12,
                                            ),
                                            Text(
                                              " " + Flag().getName(this.m.flag2),
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
                ],
              ),
              subtitle: Column(
                children: [
                  this.m.eta == "LIVE" ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          this.m.score1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NeumorphicButton(
                          child: Text(
                            'LIVE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 3,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Font2"
                            ),
                          ),
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(9)),
                              depth: 4,
                              lightSource: LightSource.top,
                              color: shared.Theme.swatch2
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          this.m.score2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13
                          ),
                        ),
                      ),
                    ],
                  )
                      :
                  Text(
                    DateFormat("EEE, MMM d, h:mm a").format(DateTime.parse(this.m.match_time)).toString() + "\n" + this.m.eta,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13
                    ),
                  ),
                ],
              ),

              onTap: () async{

              },
            ),
          ),

          Divider(
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.grey,
          ),

          this.m.eta != "LIVE" ? SizedBox(height: 0,) : IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            team1Players[0],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team1Players[1],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team1Players[2],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team1Players[3],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team1Players[4],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  width: 20,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.grey,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          team2Players[0],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team2Players[1],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team2Players[2],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team2Players[3],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          team2Players[4],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          this.m.eta != "LIVE" ? SizedBox(height: 0,) : Divider(
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.grey,
          ),

          Expanded(
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
                        'Stream '+(index + 1).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      onPressed: () async{
                        await launchUrl(
                          Uri.parse(streamLinks[index]),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  );
                }
            ),
          )
        ],
      )
    );
  }
}
