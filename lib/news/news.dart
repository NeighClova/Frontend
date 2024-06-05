import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/news/generate_news.dart';
import 'package:flutter_neighclova/news/news_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'news_response.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static final storage = FlutterSecureStorage();
  dynamic accesstoken = '';
  List<News>? newsList = [];

  @override
  void initState() {
    super.initState();
    getAllNewsAction();
  }

  getAllNewsAction() async {
    var dio = Dio();
    dio.options.baseUrl = 'http://10.0.2.2:8080';
    accesstoken = await storage.read(key: 'token');

    // 헤더 설정
    dio.options.headers['Authorization'] = 'Bearer $accesstoken';

    // 파라미터 설정
    Map<String, dynamic> queryParams = {
      'placeId': 1,
    };

    try {
      Response response =
          await dio.get('/news/all', queryParameters: queryParams);

      if (response.statusCode == 200) {
        NewsResponse newsResponse = NewsResponse.fromJson(response.data);

        setState(() {
          newsList = newsResponse.newsList;
        });

        return;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
          itemCount: newsList?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            var news = newsList?[index];
            return NewsCard(
                number: index + 1,
                title: news?.title ?? '',
                content: news?.content ?? '',
                placeName: news?.placeName ?? '',
                createdAt: news?.createdAt ?? '',
                profileImg: news?.profileImg ?? '');
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 20,
            );
          }),
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
