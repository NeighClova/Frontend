import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsCard extends StatefulWidget {
	//const NewsCard({Key? key}) : super(key: key);

  final number;
  NewsCard({this.number});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
	Widget build(BuildContext context) {
		return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          //사진
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
                  child: Center(child: Text('사진'),),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                //식당 이름, 날짜
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('식당 이름',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                        ),
                        Text('날짜',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                //복사하기 버튼
                SizedBox(
                  width: 120,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: (){

                      },
                      child: const Text('복사하기',
                        style: TextStyle(color: Color(0xff03AA5A), fontSize: 12)),
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
            )
          ),
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.white,
            child: Center(child: Text('내용'),),
          ),
        ],
      ),
		);
	}
}