import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valmob/models/news.dart' as model;
import 'package:valmob/screens/news/newsListView.dart';
import 'package:valmob/services/news.dart' as services;

class NewsView extends StatelessWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<model.News>>.value(
        value: services.News().getNews,
        initialData: [],
      child: NewsListView(),
    );
  }
}
