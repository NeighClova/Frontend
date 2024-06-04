import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/place/edit_info.dart';
import 'package:flutter_neighclova/mypage/mypage.dart';
import 'package:flutter_neighclova/news/news.dart';
import 'package:flutter_neighclova/place/register_info.dart';
import 'dart:ui';

import 'package:flutter_neighclova/tabview.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
//가게들 넘겨받기
  List<Store> stores = [];
  int selectedIndex = 0;

  final GlobalKey _containerKey = GlobalKey();
  double _containerHeight = 0;

  final GlobalKey _wrapKey = GlobalKey();
  double _wrapHeight = 0;

  final GlobalKey _goodFeedbackKey = GlobalKey();
  double _goodFeedbackHeight = 0;

  final GlobalKey _badFeedbackKey = GlobalKey();
  double _badFeedbackHeight = 0;

  //키워드
  List<String> keywords = [];

  //피드백
  String goodFeedback = '음식이 맛있고 사장님이 친절해요.';
  String badFeedback = '음식에 먼지가 나왔어요. 위생에 유의해 주세요.';

  //소식 생성 날짜
  int afterGenerateNews = 0;

  void _updateContainerHeight(StateSetter bottomState) {
    final RenderBox? renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _containerHeight = renderBox.size.height;
      });
    }
    print('컨테이터 크기 : ${_containerHeight}');
  }

  void _updateWrapHeight() {
    final RenderBox? renderBox =
        _wrapKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _wrapHeight = renderBox.size.height;
      });
    }
    print('wrap 크기 : ${_wrapHeight}');
  }

  void _updateGoodFeedbackHeight() {
    final RenderBox? renderBox =
        _goodFeedbackKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _goodFeedbackHeight = renderBox.size.height;
      });
    }
    print('wrap 크기 : ${_goodFeedbackHeight}');
  }

  void _updateBadFeedbackHeight() {
    final RenderBox? renderBox =
        _badFeedbackKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _badFeedbackHeight = renderBox.size.height;
      });
    }
    print('wrap 크기 : ${_badFeedbackHeight}');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (!isRegistered) {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (BuildContext context) => RegisterInfo()));
      // }
      _updateWrapHeight();
      _updateGoodFeedbackHeight();
      _updateBadFeedbackHeight();
    });
    //현재 가게 이름 세팅
    storeName = '소곤 식당';

    //전체 가게 이름
    stores.addAll([
      Store('소곤 식당', 'assets/storeImg.png'),
      Store('소곤 카페', ''),
    ]);

    //바텀시트 가게 선택 상태

    //키워드 세팅
    keywords.addAll(['데이트', '애견동반', '테라스', '뷰가 좋아요', '가족모임']);

    //피드백 세팅
    goodFeedback = '😊 ' + goodFeedback;
    badFeedback = '☹️ ' + badFeedback;

    //소식 생성 날짜 세팅
    afterGenerateNews = 10;
  }

  // bool isRegistered = false;
  String storeName = '';

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
        title: Image(
          image: AssetImage('assets/logo.png'),
          width: 130.0,
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 67,
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
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        storeName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff404040),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter bottomState) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) =>
                                          _updateContainerHeight(bottomState));
                                  void onButtonPressed(int index) {
                                    storeName = stores[index].storeName;
                                    bottomState(() {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    });
                                    Navigator.pop(context);
                                    (context as Element).reassemble();
                                  }

                                  return Container(
                                    height: 114 + 64.0 * (stores.length + 1),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xffF9FFE1),
                                            Color(0xffFFEDED),
                                            Color(0xffFDF6FF),
                                            Color(0xffFCFFE9),
                                            Color(0xffEAFFF5),
                                            Color(0xffF0FBFF),
                                          ]),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 10, 20, 23),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 5,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 17),
                                          ),
                                          Container(
                                            key: _containerKey,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Flexible(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: stores.length + 1,
                                                itemBuilder: (context, index) {
                                                  if (index == stores.length) {
                                                    return ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            Color(0xffF2F2F2),
                                                        child: ClipOval(
                                                          child: Icon(Icons.add,
                                                              color: Color(
                                                                  0xff656565)),
                                                        ),
                                                      ),
                                                      title: TextButton(
                                                        onPressed: () {
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        RegisterInfo()),
                                                          );
                                                        },
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '내 업체 추가',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      trailing: null,
                                                    );
                                                  } else {
                                                    return ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.grey[400],
                                                        child: ClipOval(
                                                            child: stores[index]
                                                                        .imgUrl !=
                                                                    ''
                                                                ? Image.asset(
                                                                    stores[index]
                                                                        .imgUrl,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                      ),
                                                      title: TextButton(
                                                          onPressed: () =>
                                                              onButtonPressed(
                                                                  index),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              stores[index]
                                                                  .storeName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          )),
                                                      trailing: selectedIndex ==
                                                              index
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color: Color(
                                                                  0xff468F4F))
                                                          : null,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 11),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MyPage()));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                side: BorderSide(
                                                  color: Color(0xff878787),
                                                  width: 0.3,
                                                ),
                                                elevation: 0,
                                              ),
                                              child: Text(
                                                '내 업체 정보 페이지로 이동',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '업체 변경하기',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff949494),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff949494),
                              size: 20,
                            ),
                          ],
                        ),
                        style: ButtonStyle(
                          alignment: Alignment.centerRight,
                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              Container(
                width: double.infinity,
                height: 129 + _wrapHeight,
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
                      Padding(padding: EdgeInsets.only(top: 22)),
                      Wrap(
                        key: _wrapKey,
                        spacing: 34.0,
                        runSpacing: 5.0,
                        alignment: WrapAlignment.center,
                        children: List.generate(keywords.length, (index) {
                          return buildKeywordsChips(index);
                        }),
                      ),
                      Padding(padding: EdgeInsets.only(top: 22)),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              Container(
                width: double.infinity,
                height: 145 + _goodFeedbackHeight + _badFeedbackHeight,
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
                      Padding(padding: EdgeInsets.only(top: 22)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          goodFeedback,
                          key: _goodFeedbackKey,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          badFeedback,
                          key: _badFeedbackKey,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 27)),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              Container(
                width: double.infinity,
                height: 188,
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
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '소식',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff404040),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                            text: TextSpan(
                                text: '새로운 소식 글을 작성한지 ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff404040),
                                ),
                                children: <TextSpan>[
                              TextSpan(
                                text: afterGenerateNews.toString() + '일',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff03AA5A),
                                ),
                              ),
                              TextSpan(
                                text: '이 지났어요.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff404040),
                                ),
                              ),
                            ])),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '매장 홍보를 위해 소식 글을 업로드해 보세요.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff404040),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 13)),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final tabViewState = TabView.of(context);
                            if (tabViewState != null) {
                              tabViewState.navigateToNewsPage();
                            } else {
                              print('탭바 오류');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: BorderSide(
                              color: Color(0xff03AA5A),
                              width: 1,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            '소식 글 생성하기',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff03AA5A)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildKeywordsChips(index) {
    return Chip(
      labelPadding: EdgeInsets.all(0),
      label: SizedBox(
        width: keywords[index].length * 15.0,
        child: Align(
          alignment: Alignment.center,
          child: Text(keywords[index],
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              )),
        ),
      ),
      backgroundColor: Color(0xff03AA5A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.transparent),
      ),
      elevation: 0,
    );
  }
}

class Store {
  String storeName;
  String imgUrl;
  Store(this.storeName, this.imgUrl);
}
