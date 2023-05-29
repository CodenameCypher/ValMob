import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valmob/models/matches.dart' as model;
import 'package:valmob/services/Scraper.dart';
import 'package:valmob/shared/loading.dart';
import 'package:valmob/shared/theme.dart' as shared;
import '../services/flags.dart';

class MatchPage extends StatefulWidget {
  model.Match m;
  MatchPage({required this.m});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  Map<String, dynamic> extraInfo = {};
  bool isLoading = true;
  List<List<String>> streamLinks = [];
  List<String> team1Players = ["-","-","-","-","-"];
  List<String> team2Players = ["-","-","-","-","-"];
  List<List<String>> maps = [];

  @override
  Widget build(BuildContext context) {
    Scraper().scrapeSite("https://vlr.gg"+widget.m.match_url).then((value){
      setState(() {
        extraInfo = value;
        streamLinks = widget.m.eta.split(" ").last == 'ago' ? extraInfo['vods']! : extraInfo['streams']!;
        team1Players = extraInfo['team_one_players']!;
        team2Players = extraInfo['team_two_players']!;
        maps = extraInfo['maps'];
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
      body: this.isLoading ? Loading() : Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: MediaQuery.of(context).size.height,
        color: shared.Theme.swatch1,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20))
              ),
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.03,
                    alignment: Alignment.center,
                    child: Text(
                      this.widget.m.event_name,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.13,
                    child: Row(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(bottom: 7),
                                    child: extraInfo['logo1'] == "/img/vlr/tmp/vlr.png" ?
                                    Image.network("https://vlr.gg"+extraInfo['logo1'], height: 40,width: 40)
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
                                      Image.network("https://vlr.gg"+extraInfo['logo2'], height: 40,width: 40)
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
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            this.widget.m.score1 != "-" ? this.widget.m.score1 : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13
                            ),
                          ),
                        ),
                        this.widget.m.eta == "LIVE" ? Expanded(
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
                        )
                            :
                        Text(
                          DateFormat("EEE, MMM d, h:mm a").format(DateTime.parse(extraInfo['DateTime']!)).toString() + "\n" + this.widget.m.eta,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            this.widget.m.score2 != "-" ? this.widget.m.score2 : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            this.maps.isNotEmpty?
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.grey),
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/maps/' + extraInfo['maps'][0][2] + '.jpg',
                            width: MediaQuery.of(context).size.width * 0.13,
                            fit: BoxFit.cover,
                            opacity: extraInfo['maps'][0][1] == 'ban' ? AlwaysStoppedAnimation(.5) : AlwaysStoppedAnimation(1),
                          ),
                          extraInfo['maps'][0][1] == 'ban' ?
                          Icon(
                            Icons.close,
                            size: MediaQuery.of(context).size.width * 0.13,
                            color: Colors.red.shade800,
                          )
                              :
                          SizedBox(height:0),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][0][0].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          ),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][0][2][0].toUpperCase()+extraInfo['maps'][0][2].substring(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),

                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.grey),
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/maps/' + extraInfo['maps'][1][2] + '.jpg',
                            width: MediaQuery.of(context).size.width * 0.13,
                            fit: BoxFit.cover,
                            opacity: extraInfo['maps'][1][1] == 'ban' ? AlwaysStoppedAnimation(.5) : AlwaysStoppedAnimation(1),
                          ),
                          extraInfo['maps'][1][1] == 'ban' ?
                          Icon(
                            Icons.close,
                            size: MediaQuery.of(context).size.width * 0.13,
                            color: Colors.red.shade800,
                          )
                              :
                          SizedBox(height:0),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][1][0].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          ),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][1][2][0].toUpperCase()+extraInfo['maps'][1][2].substring(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),

                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.grey),
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/maps/' + extraInfo['maps'][2][2] + '.jpg',
                            width: MediaQuery.of(context).size.width * 0.13,
                            fit: BoxFit.cover,
                            opacity: extraInfo['maps'][2][1] == 'ban' ? AlwaysStoppedAnimation(.5) : AlwaysStoppedAnimation(1),
                          ),
                          extraInfo['maps'][2][1] == 'ban' ?
                          Icon(
                            Icons.close,
                            size: MediaQuery.of(context).size.width * 0.13,
                            color: Colors.red.shade800,
                          )
                              :
                          SizedBox(height: 0),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][2][0].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          ),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][2][2][0].toUpperCase()+extraInfo['maps'][2][2].substring(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),

                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.grey),
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/maps/' + extraInfo['maps'][3][2] + '.jpg',
                            width: MediaQuery.of(context).size.width * 0.13,
                            fit: BoxFit.cover,
                            opacity: extraInfo['maps'][3][1] == 'ban' ? AlwaysStoppedAnimation(.5) : AlwaysStoppedAnimation(1),
                          ),
                          extraInfo['maps'][3][1] == 'ban' ?
                          Icon(
                            Icons.close,
                            size: MediaQuery.of(context).size.width * 0.13,
                            color: Colors.red.shade800,
                          )
                              :
                          SizedBox(height:0),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][3][0].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          ),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][3][2][0].toUpperCase()+extraInfo['maps'][3][2].substring(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),

                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.grey),
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/maps/' + extraInfo['maps'][4][2] + '.jpg',
                            width: MediaQuery.of(context).size.width * 0.13,
                            fit: BoxFit.cover,
                            opacity: extraInfo['maps'][4][1] == 'ban' ? AlwaysStoppedAnimation(.5) : AlwaysStoppedAnimation(1),
                          ),
                          extraInfo['maps'][4][1] == 'ban' ?
                          Icon(
                            Icons.close,
                            size: MediaQuery.of(context).size.width * 0.13,
                            color: Colors.red.shade800,
                          )
                              :
                          SizedBox(height:0),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][4][0].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          ),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][4][2][0].toUpperCase()+extraInfo['maps'][4][2].substring(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),

                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.grey),
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/maps/' + extraInfo['maps'][5][2] + '.jpg',
                            width: MediaQuery.of(context).size.width * 0.13,
                            fit: BoxFit.cover,
                            opacity: extraInfo['maps'][5][1] == 'ban' ? AlwaysStoppedAnimation(.5) : AlwaysStoppedAnimation(1),
                          ),
                          extraInfo['maps'][5][1] == 'ban' ?
                          Icon(
                            Icons.close,
                            size: MediaQuery.of(context).size.width * 0.13,
                            color: Colors.red.shade800,
                          )
                              :
                          SizedBox(height:0),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][5][0].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          ),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][5][2][0].toUpperCase()+extraInfo['maps'][5][2].substring(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),

                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.grey),
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/maps/' + extraInfo['maps'][6][0] + '.jpg',
                            width: MediaQuery.of(context).size.width * 0.13,
                            fit: BoxFit.cover,
                            opacity: AlwaysStoppedAnimation(1),
                          ),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  "Decider",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          ),
                          Container(
                              color: Colors.transparent,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                width: double.infinity,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  extraInfo['maps'][6][0][0].toUpperCase()+extraInfo['maps'][6][0].substring(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),
                ],
              ),
            )
                :
            Container(
                height: MediaQuery.of(context).size.height * 0.10,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Maps",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Maps not decided yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontStyle: extraInfo['maps']! == '---' ? FontStyle.italic : FontStyle.normal,
                          height: 2
                      ),
                    ),
                  ],
                )
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              child: SingleChildScrollView(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        decoration: BoxDecoration(
                            color: shared.Theme.swatch1Lighter
                        ),
                        child: TabBar(
                          indicatorColor: Colors.amberAccent,
                          tabs: [
                            Tooltip(
                              message: widget.m.team_one_name + "'s statistics",
                              child: Tab(
                                icon: Image.network(extraInfo['logo1']! == '/img/vlr/tmp/vlr.png' ? "https://vlr.gg"+extraInfo['logo1']! :"https:"+extraInfo['logo1']!, height: 24, width: 24,),
                                text: extraInfo['team_one_shortForm'],
                              ),
                            ),
                            Tooltip(
                              message: widget.m.team_two_name + "'s statistics",
                              child: Tab(
                                icon: Image.network(extraInfo['logo2']! == '/img/vlr/tmp/vlr.png' ? "https://vlr.gg"+extraInfo['logo2']! : "https:"+extraInfo['logo2']!, height: 24, width: 24,),
                                text: extraInfo['team_two_shortForm'],
                              ),
                            ),
                            Tooltip(
                              message: widget.m.eta.split(" ").last == 'ago' ? "Replays" : "Streams",
                              child: Tab(
                                icon: Icon(Icons.live_tv_outlined, size: 24,),
                                text: widget.m.eta.split(" ").last == 'ago' ? "Replays" : "Streams",
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: TabBarView(
                          children: [
                            Container( //team 1 container
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(flex: 4, child: Text(extraInfo['team_one_shortForm'], textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 2, child: Text("ACS", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 1, child: Text("K", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 1, child: Text("D", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 1, child: Text("A", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 2, child: Text("HS%", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: team1Players.length,
                                      itemBuilder: (context, index){
                                        return Row(
                                          children: [
                                            Expanded(flex: 4, child: Text(team1Players[index], textAlign: TextAlign.start, style: TextStyle(color: Colors.white),)),
                                            Expanded(flex: 2, child: Text(extraInfo['team1Stats'][index][0] == "" ? "-" : extraInfo['team1Stats'][index][0], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                            Expanded(flex: 1, child: Text(extraInfo['team1Stats'][index][1] == "" ? "-" : extraInfo['team1Stats'][index][1], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                            Expanded(flex: 1, child: Text(extraInfo['team1Stats'][index][2] == "" ? "-" : extraInfo['team1Stats'][index][2], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                            Expanded(flex: 1, child: Text(extraInfo['team1Stats'][index][3] == "" ? "-" : extraInfo['team1Stats'][index][3], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                            Expanded(flex: 2, child: Text(extraInfo['team1Stats'][index][6] == "" ? "-" : extraInfo['team1Stats'][index][6], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container( //team 1 container
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(flex: 4, child: Text(extraInfo['team_two_shortForm'], textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 2, child: Text("ACS", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 1, child: Text("K", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 1, child: Text("D", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 1, child: Text("A", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                      Expanded(flex: 2, child: Text("HS%", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2, fontWeight: FontWeight.bold),)),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: team1Players.length,
                                      itemBuilder: (context, index){
                                        return Row(
                                          children: [
                                            Expanded(flex: 4, child: Text(team2Players[index], textAlign: TextAlign.start, style: TextStyle(color: Colors.white),)),
                                            Expanded(flex: 2, child: Text(extraInfo['team2Stats'][index][0] == "" ? "-" : extraInfo['team2Stats'][index][0], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                            Expanded(flex: 1, child: Text(extraInfo['team2Stats'][index][1] == "" ? "-" : extraInfo['team2Stats'][index][1], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                            Expanded(flex: 1, child: Text(extraInfo['team2Stats'][index][2] == "" ? "-" : extraInfo['team2Stats'][index][2], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                            Expanded(flex: 1, child: Text(extraInfo['team2Stats'][index][3] == "" ? "-" : extraInfo['team2Stats'][index][3], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                            Expanded(flex: 2, child: Text(extraInfo['team2Stats'][index][6] == "" ? "-" : extraInfo['team2Stats'][index][6], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 2),)),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container( //streams container
                              padding: EdgeInsets.only(top: 10),
                              child: ListView.builder(
                                  itemCount: streamLinks.length,
                                  itemBuilder: (context, index){
                                    return streamLinks[index] == "" ? SizedBox(height: 0,) : Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                                          streamLinks[index][0] == "" ? 'Stream '+(index + 1).toString() : streamLinks[index][0],
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
