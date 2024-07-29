import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  //리뷰 분석 날짜
  int daysNum = 0;
  String day = '';

  //대표 키워드
  List<Map<String, dynamic>> keywords = [];

  bool _visible = false;

  //피드백
  List<String> good = [];
  String good_feedback =
      '음식에 대한 만족도가 높아요. 음식의 맛을 꾸준히 유지해주세요. 서비스에 만족하는 손님이 많았어요. 모두가 만족할 서비스로 단골손님을 만들어보세요!';
  List<String> bad = [];
  String bad_feedback =
      '음식에서 먼지가 나왔다는 리뷰가 있었어요. 손님들의 신뢰를 유지하기 위해서 위생 관리를 강화해주세요. 음식의 양이 적다는 손님들이 많았어요. 가격 대비 만족도를 높이기 위해 음식의 양을 늘리거나 가격을 하향 조정해보세요. 매장이 좁아 대기시간이 오래 걸린다는 리뷰가 있었어요. 테이블을 재배치하거나 예약 시스템을 도입해보세요.';
  final GlobalKey _goodColumnKey = GlobalKey();
  final GlobalKey _badColumnKey = GlobalKey();
  final GlobalKey _goodFeedbackTextKey = GlobalKey();
  final GlobalKey _badFeedbackTextKey = GlobalKey();
  double _goodContainerHeight = 0;
  double _badContainerHeight = 0;
  double _goodFeedbackContainerHeight = 0;
  double _badFeedbackContainerHeight = 0;

  //첫 리뷰 분석 완료 여부
  bool _isBlurred = true;

  @override
  void initState() {
    super.initState();
    //블러 여부
    _isBlurred = true;

    switch (daysNum) {
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
    //키워드 세팅
    keywords.addAll([
      {'keyword': '데이트', 'ratio': 0.5},
      {'keyword': '뷰가 좋아요', 'ratio': 0.02},
      {'keyword': '테라스', 'ratio': 0.05},
      {'keyword': '가족모임', 'ratio': 0.23},
      {'keyword': '애견동반', 'ratio': 0.2},
    ]);

    //칭찬 세팅
    good.addAll(['음식이 맛있어요.', '사장님이 친절해요.']);
    good_feedback = '✏️ ' + good_feedback;

    //아쉬운점 세팅
    bad.addAll(['비위생적이에요.', '양이 적어요.', '매장이 좁아요.']);
    bad_feedback = '✏️ ' + bad_feedback;

    //칭찬, 아쉬움 컨테이너 크기
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateGoodHeight());
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateBadHeight());

    //상세 피드백 컨테이너 크기
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateGoodFeedbackHeight());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateBadFeedbackHeight());
  }

  void _updateGoodHeight() {
    final RenderBox? renderBox =
        _goodColumnKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _goodContainerHeight = renderBox.size.height;
      });
    }
  }

  void _updateBadHeight() {
    final RenderBox? renderBox =
        _badColumnKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _badContainerHeight = renderBox.size.height;
      });
    }
  }

  void _updateGoodFeedbackHeight() {
    final RenderBox? renderBox =
        _goodFeedbackTextKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _goodFeedbackContainerHeight = renderBox.size.height;
      });
    }
  }

  void _updateBadFeedbackHeight() {
    final RenderBox? renderBox =
        _badFeedbackTextKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _badFeedbackContainerHeight = renderBox.size.height;
      });
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
        title: Text('리뷰 분석',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff404040),
              fontSize: 20,
            )),
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
                            text: '회원님의 리뷰 분석 날짜는\n',
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
                        ])),
                  )),
              Padding(padding: EdgeInsets.only(top: 4)),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 11),
                    child: Text(
                      '리뷰는 7일 간격으로 자동 분석됩니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff949494),
                      ),
                    ),
                  )),
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
                    ]),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '우리 가게 대표 키워드',
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
                        child: Text(
                          'CLOVA AI가 매장 리뷰를 분석해서 뽑은 키워드예요.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff949494),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: Stack(children: [
                            ...keywords
                                .asMap()
                                .map((index, keyword) {
                                  return MapEntry(
                                    index,
                                    _buildKeywordBubble(
                                      text: keyword['keyword'],
                                      ratio: keyword['ratio'].toDouble(),
                                      position: _getPositionForKeyword(index),
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                            if (_isBlurred)
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  color: Colors.white.withOpacity(0),
                                ),
                              ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 21)),
              Container(
                width: double.infinity,
                height: 283 + _goodContainerHeight + _badContainerHeight + _goodFeedbackContainerHeight + _badFeedbackContainerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '피드백',
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
                          child: Text(
                            'CLOVA AI가 매장 리뷰를 분석해서 제공하는 피드백이에요.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff949494),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 16)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '😊 칭찬해요',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 11)),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                key: _goodColumnKey,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: good
                                    .map((good) => Padding(
                                          padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                          child: Row(
                                            children: [
                                              Icon(Icons.circle, size: 5),
                                              SizedBox(width: 8),
                                              Text(
                                                good,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            if (_isBlurred)
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(23),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 6)),
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: _goodFeedbackContainerHeight + 20,
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  good_feedback,
                                  key: _goodFeedbackTextKey,
                                  style: TextStyle(fontSize: 14, color: Color(0xff404040)),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 24,
                                    offset: Offset(0, 8),
                                  )
                                ],
                              ),
                            ),
                            if (_isBlurred)
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(23),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 24)),
                        DottedDivider(),
                        Padding(padding: EdgeInsets.only(top: 24)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '🙁 아쉬워요',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 11)),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                key: _badColumnKey,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: bad
                                    .map((bad) => Padding(
                                          padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                          child: Row(
                                            children: [
                                              Icon(Icons.circle, size: 5),
                                              SizedBox(width: 8),
                                              Text(
                                                bad,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            if (_isBlurred)
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(23),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 6)),
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: _badFeedbackContainerHeight + 20,
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  bad_feedback,
                                  key: _badFeedbackTextKey,
                                  style: TextStyle(fontSize: 14, color: Color(0xff404040)),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffF2F2F2),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 24,
                                    offset: Offset(0, 8),
                                  )
                                ],
                              ),
                            ),
                            if (_isBlurred)
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(23),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
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

  Widget _buildKeywordBubble(
      {required String text, required double ratio, required Offset position}) {
    final size = 80.0 + 100.0 * ratio;
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
                color: Color.fromARGB(
                    255,
                    180 - (ratio * 10).toInt() * 18,
                    200 - (ratio * 10).toInt() * 7,
                    0 + (ratio * 10).toInt() * 15),
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
            )));
  }
}

class DottedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedDividerPainter(),
      child: Container(
        height: 1.0,
      ),
    );
  }
}

class DottedDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xffD6D6D6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    var max = size.width;
    var dashWidth = 5.0;
    var dashSpace = 3.0;
    double startX = 0;
    while (startX < max) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
