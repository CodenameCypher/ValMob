import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:valmob/models/news.dart' as model;

class News{
  CollectionReference ref = FirebaseFirestore.instance.collection("News");
  Future<List<model.News>> fetchAPI() async{
    List<model.News> newsList = [];
    print("Fetching News API...");
    var url = Uri.parse("https://vlrggapi.vercel.app/news");
    var response = await http.get(url);
    var json = jsonDecode(Utf8Decoder().convert(response.bodyBytes))['data']['segments'];
    for(var i = 0; i < json.length; i++){
      newsList.add(model.News(
          author: json[i]['author'],
          date: json[i]['date'],
          description: json[i]['description'],
          title: json[i]['title'],
          url_path: json[i]['url_path']
      ));
    }
    print("News API Fethced.");
    return newsList;
  }

  void updateDatabase() async{
    List<model.News> newsList = await fetchAPI();
    print('Updating News Database...');
    for(var i = 0; i < newsList.length; i++){
      ref.doc(newsList[i].title).set(
        {
          'author': newsList[i].author,
          'date': DateFormat("MMMM dd, yyyy").parse(newsList[i].date),
          'description': newsList[i].description,
          'title': newsList[i].title,
          'url_path': newsList[i].url_path
        }
      );
    }
    print('Updated News Database.');
  }

  List<model.News> convertToNewsObject(QuerySnapshot s){
    return s.docs.map((e){
      return model.News(
          author: e.get('author'),
          date: e.get('date').toDate().toString(),
          description: e.get('description'),
          title: e.get('title'),
          url_path: e.get('url_path')
      );
    }).toList();
  }

  Stream<List<model.News>> get getNews{
    return ref.orderBy("date",descending: true).snapshots().map(convertToNewsObject);
  }
}