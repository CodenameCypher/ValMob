import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valmob/shared/theme.dart' as shared;

class DevView extends StatelessWidget {
  const DevView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shared.Theme.swatch1,
      body: Column(
        children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(20,20,20,0),
              child: Neumorphic(
                style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: 20,
                    intensity: 0.8,
                    shadowLightColor: shared.Theme.swatch1Lighter,
                    shadowDarkColor: shared.Theme.swatch1Lighter,
                    shape: NeumorphicShape.flat,
                    lightSource: LightSource.bottom,
                    border: NeumorphicBorder(
                        isEnabled: true,
                        color: shared.Theme.swatch1Lighter,
                        width: 2
                    )
                ),
                child: Image.asset(
                  'assets/images/dev.jpeg',
                  height: MediaQuery.of(context).size.height*0.25,
                ),
              )
          ),
          Container(
            child: Text(
                'Aditya Roy',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
          Divider(
            thickness: 2,
            indent: 33,
            endIndent: 33,
            color: shared.Theme.swatch1Lighter,
            height: 40,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(30,0,30,15),
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
                  'Facebook',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: () async{
                await launchUrl(
                  Uri.parse("https://www.facebook.com/2017roya02"),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(30,0,30,15),
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
                'Instagram',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: () async{
                await launchUrl(
                  Uri.parse("https://www.instagram.com/codenamecypher/"),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(30,0,30,15),
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
                'GitHub',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: () async{
                await launchUrl(
                  Uri.parse("https://github.com/CodenameCypher"),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(30,0,30,15),
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
                'Linked In',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: () async{
                await launchUrl(
                  Uri.parse("https://www.linkedin.com/in/adityaroy1/"),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
