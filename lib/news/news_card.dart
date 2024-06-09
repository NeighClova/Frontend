import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';

class NewsCard extends StatefulWidget {
  final int number;
  final String title;
  final String content;
  final String placeName;
  final String createdAt;
  final String profileImg;

  NewsCard({
    required this.number,
    required this.title,
    required this.content,
    required this.placeName,
    required this.createdAt,
    required this.profileImg,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final GlobalKey _titleKey = GlobalKey();
  double _titleHeight = 0;

  final GlobalKey _contentKey = GlobalKey();
  double _contentHeight = 0;

  //bool isProfileImg = false;

  void _updateTitleHeight() {
    final RenderBox? renderBox =
        _titleKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _titleHeight = renderBox.size.height;
      });
    }
    print('title 크기 : ${_titleHeight}');
  }

  void _updateContentHeight() {
    final RenderBox? renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _contentHeight = renderBox.size.height;
      });
    }
    print('content 크기 : ${_contentHeight}');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleHeight();
      _updateContentHeight();
    });
  }

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
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Color.fromRGBO(161, 182, 233, 1),
                    child: widget.profileImg != ''
                      ? Image.network('${widget.profileImg}',
                          fit: BoxFit.cover)
                      : Icon(
                          Icons.person,
                          color: Colors.white,
                        )
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
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
                  width: 80,
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
            height: 42 + _titleHeight + _contentHeight,
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key: _titleKey,
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    key: _contentKey,
                    widget.content,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
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
