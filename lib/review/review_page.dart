import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_neighclova/auth_dio.dart';

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
  dynamic placeId;

  bool isAnalyzed = false;

  getReview() async {
    var dio = await authDio(context);
    placeId = await storage.read(key: 'placeId');
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
