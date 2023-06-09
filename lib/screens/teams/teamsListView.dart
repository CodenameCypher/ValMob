import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/models/team.dart';
import 'package:valmob/screens/teams/teamsCard.dart';
import 'package:valmob/shared/loading.dart';
import 'package:valmob/shared/theme.dart' as shared;


class TeamsListView extends StatefulWidget {
  const TeamsListView({Key? key}) : super(key: key);

  @override
  State<TeamsListView> createState() => _TeamsListViewState();
}

class _TeamsListViewState extends State<TeamsListView> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    List<Team> teamsList = Provider.of<List<Team>>(context);
    return teamsList.length <= 30 ? Loading() : Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(15,10,15,5),
            child: TextField(
              maxLines: 1,
              minLines: 1,
              style: TextStyle(
                  color: Colors.white
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: shared.Theme.swatch1Light,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: shared.Theme.swatch2
                    ),
                    borderRadius: BorderRadius.circular(25)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: shared.Theme.swatch2
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                isCollapsed: false,
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                ),
              ),
              textAlignVertical: TextAlignVertical.bottom,
              onChanged: (value){
                setState(() {
                  query = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: ListView.builder(
              itemCount: teamsList.length,
              itemBuilder: (context, index){
                if(this.query == ""){
                  return Padding(
                    padding: EdgeInsets.all(0),
                    child: TeamsCard(teamsList[index]),
                  );
                }else{
                  if(teamsList[index].team.toLowerCase().startsWith(query.toLowerCase()) || teamsList[index].country.toLowerCase().startsWith(query.toLowerCase()) || teamsList[index].region.toLowerCase().contains(query.toLowerCase())){
                    return Padding(
                      padding: EdgeInsets.all(0),
                      child: TeamsCard(teamsList[index]),
                    );
                  }else{
                    return SizedBox(height: 0,);
                  }
                }
              }
          ),
        )
      ],
    );
  }
}
