import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewsCard extends StatefulWidget {
  final int number;
  final String title;
  final String content;
  final String placeName;
  final String createdAt;

  NewsCard({
    required this.number,
    required this.title,
    required this.content,
    required this.placeName,
    required this.createdAt,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          Container(
            height: 70,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Text('사진'), // 여기에 이미지 URL을 사용할 수 있습니다.
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.placeName,
                          style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          widget.createdAt,
                          style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.content));
                        showToast();
                      },
                      child: const Text(
                        '복사하기',
                        style: TextStyle(
                          color: Color(0xff03AA5A),
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(5),
                        side: BorderSide(color: Color(0xff03AA5A), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(70, 20),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 20)),
              ],
            ),
          ),
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(widget.content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showToast() {
  Fluttertoast.showToast(
    msg: '클립보드에 복사되었습니다.',
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Color(0xff404040),
    fontSize: 15,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}
