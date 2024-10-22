import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_neighclova/review/review_response.dart';
import 'loading_state_widget.dart';
import 'analyzed_state_widget.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  static final storage = FlutterSecureStorage();
  dynamic review;
  dynamic accesstoken;
  dynamic placeId;

  bool isAnalyzed = false;

  getReview() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    accesstoken = await storage.read(key: 'accessToken');
    placeId = await storage.read(key: 'placeId');

    // 헤더 설정
    dio.options.headers['Authorization'] = 'Bearer $accesstoken';
    Map<String, dynamic> queryParams = {
      'placeId': placeId,
    };

    try {
      Response response =
          await dio.get('/feedback', queryParameters: queryParams);
      if (response.statusCode == 200) {
        setState(() {
          review = Review.fromJson(response.data);
        });
        if (review.keyword != null && mounted) {
          setState(() {
            isAnalyzed = true;
          });
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isAnalyzed ? AnalyzedStateWidget(review) : LoadingStateWidget(review),
    );
  }
}
