import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/admob.dart';
import 'package:flutter_neighclova/introduction/introduction.dart';
import 'package:dio/dio.dart';
import 'package:flutter_neighclova/tabview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class GenerateIntroduction extends StatefulWidget {
  const GenerateIntroduction({Key? key}) : super(key: key);

  @override
  State<GenerateIntroduction> createState() => _GenerateIntroductionState();
}

class _GenerateIntroductionState extends State<GenerateIntroduction> {
  @override
  void initState() {
    super.initState();
    createInterstitialAd();
  }
  
  final _debouncer = Debouncer(milliseconds: 500);

  List<String> selectedPurpose = [];
  List<String> selectedService = [];
  List<String> selectedMood = [];
  static final storage = FlutterSecureStorage();
  dynamic accesstoken = '';
  String resContent = '';
  bool isLoading = false;

  InterstitialAd? _interstitialAd;

  TextEditingController emphasizeContent = TextEditingController();
  final List<Map<String, dynamic>> purpose = [
    {'purpose': '데이트', 'isSelected': false},
    {'purpose': '가족모임', 'isSelected': false},
    {'purpose': '상견례', 'isSelected': false},
    {'purpose': '파티', 'isSelected': false},
    {'purpose': '회식', 'isSelected': false},
    {'purpose': '기념일', 'isSelected': false},
    {'purpose': '비즈니스미팅', 'isSelected': false},
  ];
  final List<Map<String, dynamic>> service = [
    {'service': '단체석', 'isSelected': false},
    {'service': '룸', 'isSelected': false},
    {'service': '카운터석', 'isSelected': false},
    {'service': '좌식', 'isSelected': false},
    {'service': '입식', 'isSelected': false},
    {'service': '테라스', 'isSelected': false},
    {'service': '연인석', 'isSelected': false},
    {'service': '루프탑', 'isSelected': false},
    {'service': '1인석', 'isSelected': false},
    {'service': '주차공간', 'isSelected': false},
    {'service': '애견동반', 'isSelected': false},
    {'service': '발렛파킹', 'isSelected': false},
  ];
  final List<Map<String, dynamic>> mood = [
    {'mood': '분위기좋은', 'isSelected': false},
    {'mood': '혼밥', 'isSelected': false},
    {'mood': '혼술', 'isSelected': false},
    {'mood': '대화하기 좋은', 'isSelected': false},
    {'mood': '조용한', 'isSelected': false},
    {'mood': '이국적인', 'isSelected': false},
    {'mood': '편한좌석', 'isSelected': false},
  ];

  makeIntroduceAction() async {
    var dio = Dio();
    dio.options.baseUrl = 'http://192.168.35.197:8080';
    var placeId = await storage.read(key: 'placeId');

    // 파라미터 설정
    Map<String, dynamic> queryParams = {'placeId': placeId};

    var body = {
      "purpose": selectedPurpose,
      "service": selectedService,
      "mood": selectedMood,
      "emphasizeContent": emphasizeContent.text
    };

    try {
      Response response = await dio.post('/introduce/ai',
          queryParameters: queryParams, data: body);

      if (response.statusCode == 200) {
        setState(() {
          resContent = response.data['content'];
          print("생성완료");
        });
        return;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  saveIntroduceAction(resContent) async {
    var dio = Dio();
    dio.options.baseUrl = 'http://192.168.45.77:8080';
    accesstoken = await storage.read(key: 'token');
    var placeId = await storage.read(key: 'placeId');

    // 헤더 설정
    dio.options.headers['Authorization'] = 'Bearer $accesstoken';

    var body = {'placeId': placeId, 'content': resContent};

    try {
      Response response = await dio.post('/introduce', data: body);

      if (response.statusCode == 200) {
        print('save success');
        return true;
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: admob.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }
  
  void showInterstitialAd() {
    if (_interstitialAd != null) {
      // 전체 화면 모드 설정
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createInterstitialAd();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        },
      );
      _interstitialAd!.show();
      createInterstitialAd();
    }
  }

  void _handleButtonPressed() {
    setState(() {
      isLoading = true;
    });

    showInterstitialAd();

    makeIntroduceAction().then((_) {
      setState(() {
        isLoading = false;
      });

      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter bottomState) {
              return Container(
                height: 470,
                decoration: BoxDecoration(
                  color: Colors.white, // 배경색 지정
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '선택된 키워드를 기반으로\n소개글을 생성했어요!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff404040),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Container(
                            width: double.infinity,
                            height: 270,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                              child: Text(
                                resContent,
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff404040)),
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
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print('재생성버튼 클릭');
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GenerateIntroduction()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffF2F2F2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(130, 50),
                          ),
                          child: Text(
                            '재생성',
                            style: TextStyle(
                                fontSize: 17, color: Color(0xff404040)),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        ElevatedButton(
                          onPressed: () {
                            saveIntroduceAction(resContent);
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff03AA5A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(230, 50),
                          ),
                          child: Text(
                            '적용하기',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            });
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffFFFFFF),
            scrolledUnderElevation: 0,
            elevation: 0,
            shape: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.1),
                width: 3,
              ),
            ),
            title: Text('소개 생성',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff404040),
                  fontSize: 20,
                )),
            centerTitle: true,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('우리 가게 키워드',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff404040),
                          fontSize: 20,
                        )),
                    Padding(padding: EdgeInsets.only(top: 25)),
                    Text('방문 목적',
                        style: TextStyle(
                          color: Color(0xff656565),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: List.generate(purpose.length, (index) {
                        return buildPurposeChips(index);
                      }),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25)),
                    Text('시설 & 서비스',
                        style: TextStyle(
                          color: Color(0xff656565),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: List.generate(service.length, (index) {
                        return buildServiceChips(index);
                      }),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25)),
                    Text('분위기',
                        style: TextStyle(
                          color: Color(0xff656565),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: List.generate(mood.length, (index) {
                        return buildMoodChips(index);
                      }),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25)),
                    Text('강조하고 싶은 내용 추가',
                        style: TextStyle(
                          color: Color(0xff656565),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(top: 14)),
                    TextFormField(
                      controller: emphasizeContent,
                      minLines: 3,
                      maxLines: 5,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          hintText:
                              '추천 메뉴나 맛 설명 등 추가/강조하고 싶은 내용을 작성해주세요.\n예) 인기 메뉴 마라 쌀국수, 당일 예약 가능, 이국적인 맛',
                          hintStyle: TextStyle(
                            color: Color(0xffA1A1A1),
                            fontSize: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 60,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: ElevatedButton(
                onPressed: _handleButtonPressed,
                child: Text(
                  '키워드 기반 맞춤 소개 글 생성하기',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff03AA5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '생성중입니다.',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildPurposeChips(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: purpose[index]['purpose'].length * 15.0,
          child: Align(
            alignment: Alignment.center,
            child: Text(purpose[index]['purpose'],
                style: TextStyle(
                  color: purpose[index]['isSelected']
                      ? Colors.white
                      : Colors.black,
                  fontSize: 12,
                )),
          ),
        ),
        selected: purpose[index]['isSelected'],
        selectedColor: Color(0xff03AA5A),
        backgroundColor: Color(0xffF2F2F2),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
        onSelected: (value) {
          setState(() {
            purpose[index]['isSelected'] = !purpose[index]['isSelected'];
            //추가된 부분
            if (purpose[index]['isSelected']) {
              selectedPurpose.add(purpose[index]['purpose']);
            } else {
              selectedPurpose.remove(purpose[index]['purpose']);
            }
          });
        },
        elevation: 0,
      ),
    );
  }

  Widget buildServiceChips(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: service[index]['service'].length * 15.0,
          child: Align(
            alignment: Alignment.center,
            child: Text(service[index]['service'],
                style: TextStyle(
                  color: service[index]['isSelected']
                      ? Colors.white
                      : Colors.black,
                  fontSize: 12,
                )),
          ),
        ),
        selected: service[index]['isSelected'],
        selectedColor: Color(0xff03AA5A),
        backgroundColor: Color(0xffF2F2F2),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
        onSelected: (value) {
          setState(() {
            service[index]['isSelected'] = !service[index]['isSelected'];
            //추가된 부분
            if (service[index]['isSelected']) {
              selectedService.add(service[index]['service']);
            } else {
              selectedService.remove(service[index]['service']);
            }
          });
        },
        elevation: 0,
      ),
    );
  }

  Widget buildMoodChips(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: mood[index]['mood'].length * 15.0,
          child: Align(
            alignment: Alignment.center,
            child: Text(mood[index]['mood'],
                style: TextStyle(
                  color:
                      mood[index]['isSelected'] ? Colors.white : Colors.black,
                  fontSize: 12,
                )),
          ),
        ),
        selected: mood[index]['isSelected'],
        selectedColor: Color(0xff03AA5A),
        backgroundColor: Color(0xffF2F2F2),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
        onSelected: (value) {
          setState(() {
            mood[index]['isSelected'] = !mood[index]['isSelected'];
            //추가된 부분
            if (mood[index]['isSelected']) {
              selectedMood.add(mood[index]['mood']);
            } else {
              selectedMood.remove(mood[index]['mood']);
            }
          });
        },
        elevation: 0,
      ),
    );
  }
}
