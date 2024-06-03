import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/news/generate_news.dart';
import 'package:flutter_neighclova/news/news_card.dart';

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
        scrolledUnderElevation: 0,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 3,
          ),
        ),
        title: Text('소식 생성',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff404040),
              fontSize: 20,
            )),
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
          return SizedBox(
            height: 20,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => GenerateNews()));
        },
        child: Icon(Icons.edit),
        backgroundColor: Color(0xff03AA5A),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
    );
  }
}
