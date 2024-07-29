import 'package:flutter/material.dart';
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
  dynamic placeId;
  List<News>? newsList = [];

  @override
  void initState() {
    super.initState();
    getAllNewsAction();
  }

  Future<List<News>?> getAllNewsAction() async {
    var dio = Dio();
    dio.options.baseUrl = 'http://192.168.45.77:8080';
    accesstoken = await storage.read(key: 'token');
    placeId = await storage.read(key: 'placeId');

    // 헤더 설정
    dio.options.headers['Authorization'] = 'Bearer $accesstoken';
    // 파라미터 설정
    Map<String, dynamic> queryParams = {
      'placeId': placeId,
    };
    try {
      Response response =
          await dio.get('/news/all', queryParameters: queryParams);
      if (response.statusCode == 200) {
        NewsResponse newsResponse = NewsResponse.fromJson(response.data);
        newsList = newsResponse.newsList;

        return newsList;
      } else {
        print('Error: ${response.statusCode}');
        return newsList;
      }
    } catch (e) {
      print('Error: $e');
      return newsList;
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
      //
      body: FutureBuilder<List<News>?>(
        future: getAllNewsAction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            newsList = snapshot.data;
            if (newsList?.length == 0) {
              return Align(
                alignment: Alignment.center,
                child: Text(
                  '아직 소식글을 생성하지 않으셨네요!\n홍보/공지 등, 매장의 소식 작성해서 고객들에게 전해보세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff404040),
                  ),
                ),
              );
            }
            return ListView.separated(
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
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => GenerateNews()));

          if (result == true) {
            await getAllNewsAction();
            setState(() {});
          }
        },
        child: Icon(Icons.edit),
        backgroundColor: Color(0xff03AA5A),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
    );
  }
}
