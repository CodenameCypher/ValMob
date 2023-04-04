import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valmob/models/news.dart';
import 'package:valmob/shared/theme.dart' as shared;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  final News news;
  NewsCard({required this.news});


  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
            depth: 1.4,
            lightSource: LightSource.bottom,
            color: shared.Theme.swatch1
        ),
      child: Container(
        padding: EdgeInsets.fromLTRB(0,10,0,10),
        child: ListTile(
          title: Text(
              this.news.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "By " + this.news.author + " on " + DateFormat("MMMM dd, yyyy",'en-us').format(DateTime.parse(this.news.date)),
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                this.news.description,
                style: TextStyle(
                    color: Colors.white60
                ),
              ),
            ],
          ),
          onTap: () async{
            await launchUrl(
                Uri.parse('https://vlr.gg'+this.news.url_path),
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

