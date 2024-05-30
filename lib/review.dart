import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Review extends StatefulWidget {
	const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  int daysNum = 0;
  String day = '';
  List<Map<String, dynamic>> keywords = [
    {'keyword': '키워드1', 'ratio': 0.5},
    {'keyword': '키워드2', 'ratio': 0.02},
    {'keyword': '키워드3', 'ratio': 0.05},
    {'keyword': '키워드4', 'ratio': 0.23},
    {'keyword': '키워드5', 'ratio': 0.2},
  ];
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    ////요일, 키워드, 피드백 세팅
    switch(daysNum) {
      case 0:
        day = '월요일';
        break;
      case 1:
        day = '화요일';
        break;
      case 2:
        day = '수요일';
        break;
      case 3:
        day = '목요일';
        break;
      case 4:
        day = '금요일';
        break;
      case 5:
        day = '토요일';
        break;
      case 6:
        day = '일요일';
        break;
    }
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      });
    });
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
        title: Text('리뷰 분석',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff404040),
            fontSize: 20,
          )
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 25, 16, 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 11),
                  child: RichText(
                    text: TextSpan(
                      text: '회원님의 확인 가능한 날짜는\n',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff404040),
                      ), 
                      children: <TextSpan>[
                        TextSpan(
                          text: day,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff03AA5A),
                          ),  
                        ),
                        TextSpan(
                          text: ' 입니다.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff404040),
                          ), 
                        ),
                      ]
                    )
                  ),
                )
              ),
              Padding(padding: EdgeInsets.only(top: 4)),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 11),
                  child: Text('리뷰는 7일 간격으로 자동 분석됩니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff949494),
                    ),
                  ),
                )
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('우리 가게 대표 키워드',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff404040),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 4)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('CLOVA AI가 매장 리뷰를 분석해서 뽑은 키워드예요.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff949494),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: keywords
                              .asMap() // 변경된 부분: asMap 사용
                              .map((index, keyword) => MapEntry(
                                    index,
                                    _buildKeywordBubble(
                                      text: keyword['keyword'],
                                      ratio: keyword['ratio'].toDouble(), // 변경된 부분: ratio를 double로 변환
                                      position: _getPositionForKeyword(index),
                                    ),
                                  ))
                              .values
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
		);
	}

  //원 위치
  Offset _getPositionForKeyword(int index) {
    switch (index) {
      case 0:
        return Offset(10, 20);
      case 1:
        return Offset(140, 70);
      case 2:
        return Offset(250, 40);
      case 3:
        return Offset(70, 150);
      case 4:
        return Offset(200, 160);
      default:
        return Offset(0, 0);
    }
  }

  Widget _buildKeywordBubble({required String text, required double ratio, required Offset position}) {
    final size = 80.0 + 100.0 * ratio; // 크기를 비율에 따라 조정
    return AnimatedPositioned(
      duration: Duration(seconds: 1),
      left: _visible ? position.dx : position.dx,
      top: _visible ? position.dy : position.dy - 10,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(seconds: 1),
        child: Container(
          width: size.toDouble(),
          height: size.toDouble(),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 180 - (ratio * 10).toInt() * 18, 200 - (ratio * 10).toInt() * 7, 0 + (ratio * 10).toInt() * 15),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      /*child: Positioned(
        left: position.dx,
        top: position.dy,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 180 - (ratio * 10).toInt() * 18, 200 - (ratio * 10).toInt() * 7, 0 + (ratio * 10).toInt() * 15)/*.withOpacity(0.5 + ratio)*/,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      )*/
      )
    );
  }
}