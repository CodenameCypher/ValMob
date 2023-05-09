import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:valmob/models/matches.dart' as model;
import 'package:valmob/screens/previousMatches/previousMatchesPage.dart';
import 'package:valmob/shared/theme.dart' as shared;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:valmob/services/teams.dart';
import 'package:valmob/models/team.dart';
import 'package:valmob/services/flags.dart';

class PreviousMatchesCard extends StatelessWidget {
  final model.Match match;
  PreviousMatchesCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            depth: 1.4,
            lightSource: LightSource.top,
            color: shared.Theme.swatch1Light
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0,10,0,10),
          child: ListTile(
            isThreeLine: true,
            title: Column(
              children: [
                Text(
                  this.match.event_name,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10
                  ),
                ),
                FutureBuilder(
                  future: Teams().getTeam(this.match.team_one_name, this.match.team_two_name),
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
                                  child: snapshot != null && snapshot[0] != null && snapshot[0].logo != "" ?
                                  Image.network("https:"+snapshot[0].logo, height: 40, width: 40,)
                                      :
                                  Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 40,width: 40),
                                ),
                                this.match.team_one_name.split(" ").length == 1 ? Text(
                                  this.match.team_one_name,
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
                                    text: this.match.team_one_name,
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
                                          Flag().getLink(this.match.flag1),
                                          width: 12,
                                        ),
                                        Text(
                                          " " + Flag().getName(this.match.flag1),
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
                                          this.match.event_icon_url,
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
                                    child: snapshot != null && snapshot[1] != null && snapshot[1].logo != "" ?
                                    Image.network("https:"+snapshot[1].logo, height: 40,width: 40)
                                        :
                                    Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 40,width: 40),
                                  ),
                                  this.match.team_two_name.split(" ").length == 1 ? Text(
                                    this.match.team_two_name,
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
                                      text: this.match.team_two_name,
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
                                            Flag().getLink(this.match.flag2),
                                            width: 12,
                                          ),
                                          Text(
                                            " " + Flag().getName(this.match.flag2),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        this.match.score1,
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
                        DateFormat("MMM d, h:mm a").format(DateTime.parse(this.match.match_time)).toString() + "\n" + this.match.eta,
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
                        this.match.score2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),

            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PreviousMatchesPage(m: this.match)));
            },
          ),
        )
    );
  }
}
