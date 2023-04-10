import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:valmob/models/team.dart';
import 'package:valmob/shared/theme.dart' as shared;

class TeamsCard extends StatelessWidget {
  Team team;
  TeamsCard(this.team);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            depth: 1.4,
            lightSource: LightSource.top,
            color: shared.Theme.swatch1Light
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0,10,0,10),
          color: shared.Theme.swatch1Light,
          child: ListTile(
            title: Text(
                team.team,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500
              ),
            ),
            subtitle: Text(
                team.region + " #" + team.rank,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 12
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: shared.Theme.swatch1Lighter,
              radius: 25,
              child: team.logo != "" ? Image.network("https:"+team.logo, height: 35, width: 35,) : Image.network("https://www.precisionpass.co.uk/wp-content/uploads/2018/03/default-team-logo.png", height: 35,width: 35),
            ),
            trailing: Text(
                team.country,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
      ),
    );
  }
}
