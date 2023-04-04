import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/models/news.dart' as model;
import 'package:valmob/screens/news/newsCard.dart';
import 'package:valmob/shared/loading.dart';

class NewsListView extends StatefulWidget {
  const NewsListView({Key? key}) : super(key: key);

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  @override
  Widget build(BuildContext context) {
    final List<model.News> newsList = Provider.of<List<model.News>>(context);
    return newsList.length == 0 ? Loading() : ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.all(5),
              child: NewsCard(news: newsList[index])
          );
        }
    );
  }
}
