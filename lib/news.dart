import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/generate_news.dart';
import 'package:flutter_neighclova/news_card.dart';
import 'package:flutter_neighclova/shared/bottom.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          )
        ),
        title: Text('소식 생성',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          )
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xffF5F5F5),
      body: ListView.separated(
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return NewsCard(
            number: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 20,);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                GenerateNews())
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Color(0xff03AA5A),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
    );
  }
}