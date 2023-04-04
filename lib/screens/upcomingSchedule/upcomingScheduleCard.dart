import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valmob/models/matches.dart' as model;
import 'package:valmob/shared/theme.dart' as shared;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valmob/services/teams.dart';
import 'package:valmob/models/team.dart';

class UpcomingScheduleCard extends StatelessWidget {
  final model.Match match;
  UpcomingScheduleCard({required this.match});

  @override
  Widget build(BuildContext context){

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
            trailing: this.match.eta != "LIVE" ? SizedBox(height: 0,) : NeumorphicButton(
              child: Text(
                  'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(9)),
                  depth: 3,
                  lightSource: LightSource.bottom,
                  color: shared.Theme.swatch7Dark
              ),
            ),
            title: FutureBuilder(
              future: Teams().getTeam(this.match.team_one_name, this.match.team_two_name),
              builder: (context, t){
                List<Team>? snapshot = t.data;
                // print(snapshot![0].logo);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                        child: Column(
                          children: [
                            snapshot != null && snapshot[0] != null && snapshot[0].logo != "" ? Image.network("https:"+snapshot[0].logo, height: 30, width: 30,) : Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 30,width: 30),
                            Text(
                              this.match.team_one_name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                    ),
                    Expanded(
                      flex: 2,
                        child: Text(
                          "V/S",
                          style: TextStyle(
                              color: Colors.white,
                            fontSize: 20
                          ),
                        )
                    ),
                    Expanded(
                      flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            snapshot != null && snapshot[1] != null && snapshot[1].logo != "" ?Image.network("https:"+snapshot[1].logo, height: 30,width: 30) : Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 30,width: 30),
                            Text(
                              this.match.team_two_name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                );
              },
            ),
            // title: Text(
            //   this.match.team_one_name + " V/S " + this.match.team_two_name,
            //   style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 17
            //   ),
            // ),
            subtitle: this.match.eta == "LIVE" ?
            Text(
              "Score: " + this.match.score1 + " - " + this.match.score2,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13
              ),
            )
                :
            Text(
              this.match.match_time + " - " + this.match.eta,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13
              ),
            ),
            onTap: () async{
              print(this.match.match_url);
              await launchUrl(
                  Uri.parse("https://vlr.gg"+this.match.match_url),
                  mode: LaunchMode.inAppWebView
              );
            },
          ),
        )
    );
    // return Text(
    //     this.news.title,
    //     style: TextStyle(
    //         color: Colors.white
    //     ),
    //   );
  }
}

