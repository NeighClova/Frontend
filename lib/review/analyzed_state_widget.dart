import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

class AnalyzedStateWidget extends StatefulWidget {
  final dynamic review; // 리뷰 데이터를 저장할 변수

  const AnalyzedStateWidget(this.review, {Key? key}) : super(key: key);

  @override
  State<AnalyzedStateWidget> createState() => _ReviewState();
}

class _ReviewState extends State<AnalyzedStateWidget> {
  List<Map<String, dynamic>> keywords = [];
  List<String> good = [];
  String good_feedback = '';
  List<String> bad = [];
  String bad_feedback = '';

  bool _visible = false;

  final GlobalKey _goodColumnKey = GlobalKey();
  final GlobalKey _badColumnKey = GlobalKey();
  final GlobalKey _goodFeedbackTextKey = GlobalKey();
  final GlobalKey _badFeedbackTextKey = GlobalKey();
  double _goodContainerHeight = 0;
  double _badContainerHeight = 0;
  double _goodFeedbackContainerHeight = 0;
  double _badFeedbackContainerHeight = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _visible = true;
      });
    });

    keywords.addAll([
      {'keyword': widget.review.keyword[0], 'ratio': 0.5},
      {'keyword': widget.review.keyword[1], 'ratio': 0.02},
      {'keyword': widget.review.keyword[2], 'ratio': 0.05},
      {'keyword': widget.review.keyword[3], 'ratio': 0.23},
      {'keyword': widget.review.keyword[4], 'ratio': 0.2},
    ]);

    good.addAll(widget.review.pSummary
        .map((e) => e.toString())
        .where((e) => e != null)
        .cast<String>());
    good_feedback = '✏️ ' + widget.review.pBody;

    bad.addAll(widget.review.nSummary
        .map((e) => e.toString())
        .where((e) => e != null)
        .cast<String>());
    bad_feedback = '✏️ ' + widget.review.nBody;

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
                            text: widget.review.updatedAt,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff03AA5A)),
                            children: const <TextSpan>[
                          TextSpan(
                            text: '\n기준으로 분석된 리뷰입니다.',
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
                          clipBehavior: Clip.none,
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
                height: 283 +
                    _goodContainerHeight +
                    _badContainerHeight +
                    _goodFeedbackContainerHeight +
                    _badFeedbackContainerHeight,
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
                                          padding:
                                              EdgeInsets.fromLTRB(15, 0, 0, 10),
                                          child: Row(
                                            children: [
                                              Icon(Icons.circle, size: 5),
                                              SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  good,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                    .toList(),
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
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xff404040)),
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
                                          padding:
                                              EdgeInsets.fromLTRB(15, 0, 0, 10),
                                          child: Row(
                                            children: [
                                              Icon(Icons.circle, size: 5),
                                              SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  bad,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  softWrap:
                                                      true, // 텍스트가 자동으로 줄바꿈되도록 함
                                                  overflow: TextOverflow
                                                      .visible, // 텍스트가 너무 길 때 표시 방법 설정
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                    .toList(),
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
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xff404040)),
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
                            /////
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

// 원 위치
  Offset _getPositionForKeyword(int index) {
    switch (index) {
      case 0:
        return Offset(0, 20);
      case 1:
        return Offset(130, 70);
      case 2:
        return Offset(210, 40);
      case 3:
        return Offset(60, 150);
      case 4:
        return Offset(170, 160);
      default:
        return Offset(0, 0);
    }
  }

  Widget _buildKeywordBubble({
    required String text,
    required double ratio,
    required Offset position,
  }) {
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
              0 + (ratio * 10).toInt() * 15,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.15, // 폰트 크기 비율 조정
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true, // 텍스트 자동 줄바꿈 설정
              overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 말줄임표 사용
            ),
          ),
        ),
      ),
    );
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
