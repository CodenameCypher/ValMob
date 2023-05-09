import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/screens/previousMatches/previousMatchesCard.dart';
import 'package:valmob/shared/loading.dart';
import 'package:valmob/models/matches.dart' as model;
import 'package:valmob/shared/theme.dart' as shared;

class PreviousMatchesListView extends StatefulWidget {
  const PreviousMatchesListView({Key? key}) : super(key: key);

  @override
  State<PreviousMatchesListView> createState() => _PreviousMatchesListViewState();
}

class _PreviousMatchesListViewState extends State<PreviousMatchesListView> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final List<model.Match> matchList = Provider.of<List<model.Match>>(context);
    return matchList.length < 50 ? Loading() : Column(
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
              itemCount: matchList.length,
              itemBuilder: (context, index){
                if(this.query == ""){
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: PreviousMatchesCard(match: matchList[index]),
                  );
                }else{
                  if(matchList[index].team_one_name.toLowerCase().startsWith(query.toLowerCase()) || matchList[index].team_two_name.toLowerCase().startsWith(query.toLowerCase()) || matchList[index].event_name.toLowerCase().contains(query.toLowerCase())){
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: PreviousMatchesCard(match: matchList[index]),
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
