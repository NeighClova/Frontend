import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neighclova/admob.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neighclova/auth_dio.dart';

class GenerateNews extends StatefulWidget {
  const GenerateNews({Key? key}) : super(key: key);

  @override
  State<GenerateNews> createState() => _GenerateNewsState();
}

class _GenerateNewsState extends State<GenerateNews> {
  String initAmPm = "";
  int initHour = 0;
  String finalAmPm = "";
  int finalHour = 0;
  String selectedKeyword = '';
  String selectedType = '';

  String resContent = '';
  String resTitle = '';
  bool isLoading = false;

  static final storage = FlutterSecureStorage();

  bool showPeriod = false;

  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
    initAmPm = initialTime.hour >= 12 && initialTime.hour < 24 ? "오후" : "오전";
    initHour = initialTime.hour > 12 && initialTime.hour <= 24
        ? initialTime.hour - 12
        : initialTime.hour;
    if (initHour == 0) initHour = 12;
    finalAmPm = finalTime.hour >= 12 && finalTime.hour < 24 ? "오후" : "오전";
    finalHour = finalTime.hour > 12 && finalTime.hour <= 24
        ? finalTime.hour - 12
        : finalTime.hour;
    if (finalHour == 0) finalHour = 12;

    showPeriod = false;

    createInterstitialAd();
  }

  final List<Map<String, dynamic>> keyword = [
    {'keyword': '알림', 'isSelected': false},
    {'keyword': '임시 휴무', 'isSelected': false},
    {'keyword': 'EVENT', 'isSelected': false},
    {'keyword': 'SALE', 'isSelected': false},
    {'keyword': 'NEW', 'isSelected': false},
  ];
  final List<Map<String, dynamic>> type = [
    {'type': '가격 인상 안내', 'isSelected': false},
    {'type': '매장 이용 안내', 'isSelected': false},
    {'type': '메뉴 홍보', 'isSelected': false},
    {'type': '깜짝 이벤트', 'isSelected': false},
  ];
  DateTime initialDay = DateTime.now();
  DateTime finalDay = DateTime.now();
  var daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
  TimeOfDay initialTime = TimeOfDay.now();
  TimeOfDay finalTime = TimeOfDay.now();
  TextEditingController newsDetail = TextEditingController();
  TextEditingController highlightContent = TextEditingController();

  makeNewsAction() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    var placeId = await storage.read(key: 'placeId');

    // 파라미터 설정
    Map<String, dynamic> queryParams = {'placeId': placeId};

    var body = {
      "keyword": selectedKeyword,
      "newsType": selectedType,
      "newsDetail": newsDetail.text,
      "startDate":
          '${initialDay.month}월 ${initialDay.day}일 ${initAmPm} ${initHour}:${initialTime.minute}',
      "endDate":
          '${finalDay.month}월 ${finalDay.day}일 ${finalAmPm} ${finalHour}:${finalTime.minute}',
      "highlightContent": highlightContent.text
    };

    try {
      Response response =
          await dio.post('/news/ai', queryParameters: queryParams, data: body);

      if (response.statusCode == 200) {
        setState(() {
          resContent = response.data['content'];
          resTitle = response.data['title'];
        });
        return;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  saveNewsAction() async {
    var dio = await authDio(context);
    var placeId = await storage.read(key: 'placeId');

    var body = {
      'placeId': placeId,
      'title': resTitle,
      'content': resContent,
      'keyword': selectedKeyword
    };

    try {
      Response response = await dio.post('/news', data: body);

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

    makeNewsAction().then((_) {
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
                        '선택된 키워드를 기반으로\n소식글을 생성했어요!',
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
                                '${resTitle}\n${resContent}',
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
                                  builder: (context) => GenerateNews()),
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
                            saveNewsAction();
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                            //setState(() {});
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => NewsPage()),
                            // );
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
    return Stack(children: [
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
          title: Text('소식 생성',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff404040),
                fontSize: 20,
              )),
          centerTitle: true,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 60,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: ElevatedButton(
                onPressed: _handleButtonPressed,
                child: Text(
                  '키워드 기반 맞춤 소식 글 생성하기',
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
        body: Stack(children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('가게 소식 키워드',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff404040),
                                      fontSize: 20,
                                    )),
                                Text('어떤 소식을 작성하시겠어요?',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    )),
                              ],
                            ),
                            Tooltip(
                              child: Icon(
                                Icons.info,
                                size: 30,
                                color: Color(0xff03AA5A),
                              ),
                              message: '주의해주세요!\n'
                                  '- 사실이 아닌 일을 출력할 수도 있어요.\n'
                                  '- 활용 전 사실 점검을 권장드려요.\n'
                                  '- 구체적으로 지시할수록 더 좋은 답변을 얻을 수 있어요.',
                              padding: EdgeInsets.all(20),
                              textStyle: TextStyle(color: Color(0xff404040)),
                              preferBelow: false,
                              verticalOffset: 15,
                              triggerMode: TooltipTriggerMode.tap,
                              showDuration: const Duration(seconds: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(keyword.length, (index) {
                              return buildKeyword(index);
                            }),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '소식 유형',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff404040),
                                  fontSize: 20,
                                ),
                              ),
                              Text('구체적으로 어떤 종류의 소식을 작성하시겠어요?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(type.length, (index) {
                              return buildType(index);
                            }),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        TextFormField(
                          controller: newsDetail,
                          minLines: 2,
                          maxLines: 5,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            isDense: true,
                            hintText: '추가로 원하는 소식의 유형을 작성해주세요.',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        if (showPeriod)
                          Padding(padding: EdgeInsets.only(top: 30)),
                        if (showPeriod)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '기간',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff404040),
                                    fontSize: 20,
                                  ),
                                ),
                                Text('특별 이벤트나 세일의 유효 기간 등을 작성해주세요.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    )),
                              ],
                            ),
                          ),
                        if (showPeriod)
                          Padding(padding: EdgeInsets.only(top: 20)),
                        if (showPeriod)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 18),
                                        foregroundColor: Color(0xff404040),
                                      ),
                                      onPressed: () async {
                                        final DateTime? dateTime =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: initialDay,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(3000),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: Color(0xff404040),
                                                  onSurface: Color(0xff404040),
                                                ),
                                                buttonTheme: ButtonThemeData(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: Color(0xff404040),
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (dateTime != null) {
                                          setState(() {
                                            initialDay = dateTime;
                                          });
                                        }
                                      },
                                      child: Text(
                                          '${initialDay.month}월 ${initialDay.day}일 (${DateFormat('E', 'ko_KR').format(initialDay)})'),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 15),
                                        foregroundColor: Color(0xff404040),
                                      ),
                                      onPressed: () async {
                                        final TimeOfDay? timeOfDay =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: initHour,
                                              minute: initialTime.minute),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: Color(0xff404040),
                                                  onSurface: Color(0xff404040),
                                                ),
                                                buttonTheme: ButtonThemeData(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: Color(0xff404040),
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (timeOfDay != null) {
                                          setState(() {
                                            initialTime = timeOfDay;
                                            initAmPm = initialTime.hour >= 12 &&
                                                    initialTime.hour < 24
                                                ? "오후"
                                                : "오전";
                                            initHour = initialTime.hour > 12 &&
                                                    initialTime.hour <= 24
                                                ? initialTime.hour - 12
                                                : initialTime.hour;
                                            if (initHour == 0) initHour = 12;
                                          });
                                        }
                                      },
                                      child: Text(
                                          '${initAmPm} ${initHour}:${initialTime.minute}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 20)),
                              Container(
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 30,
                                  color: Color(0xff404040),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 20)),
                              Container(
                                child: Column(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff404040)),
                                        foregroundColor: Color(0xff404040),
                                      ),
                                      onPressed: () async {
                                        final DateTime? dateTime =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: finalDay,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(3000),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: Color(0xff404040),
                                                  onSurface: Color(0xff404040),
                                                ),
                                                buttonTheme: ButtonThemeData(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: Color(0xff404040),
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (dateTime != null) {
                                          setState(() {
                                            finalDay = dateTime;
                                          });
                                        }
                                      },
                                      child: Text(
                                          '${finalDay.month}월 ${finalDay.day}일 (${DateFormat('E', 'ko_KR').format(finalDay)})'),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 15),
                                        foregroundColor: Color(0xff404040),
                                      ),
                                      onPressed: () async {
                                        final TimeOfDay? timeOfDay =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: finalHour,
                                              minute: finalTime.minute),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: Color(0xff404040),
                                                  onSurface: Color(0xff404040),
                                                ),
                                                buttonTheme: ButtonThemeData(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: Color(0xff404040),
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (timeOfDay != null) {
                                          setState(() {
                                            finalTime = timeOfDay;
                                            finalAmPm = finalTime.hour >= 12 &&
                                                    finalTime.hour < 24
                                                ? "오후"
                                                : "오전";
                                            finalHour = finalTime.hour > 12 &&
                                                    finalTime.hour <= 24
                                                ? finalTime.hour - 12
                                                : initialTime.hour;
                                            if (finalHour == 0) finalHour = 12;
                                          });
                                        }
                                      },
                                      child: Text(
                                          '${finalAmPm} ${finalHour}:${finalTime.minute}'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '강조하고 싶은 내용 추가',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff404040),
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        TextFormField(
                          controller: highlightContent,
                          minLines: 3,
                          maxLines: 5,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              isDense: true,
                              hintText: '추가/강조하고 싶은 내용을 작성해주세요.',
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
                        Padding(padding: EdgeInsets.only(top: 30)),
                        caution(),
                        Padding(padding: EdgeInsets.only(top: 40)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
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
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ]);
  }

  int selectedKeywordIndex = -1;
  Widget buildKeyword(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(keyword[index]['keyword'],
                style: TextStyle(
                  color: keyword[index]['isSelected']
                      ? Colors.white
                      : Color(0xff404040),
                  fontSize: 11,
                )),
          ),
        ),
        selected: selectedKeywordIndex == index,
        //selected: keyword[index]['isSelected'],
        selectedColor: Color(0xff03AA5A),
        backgroundColor: Color(0xffF2F2F2),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
        onSelected: (value) {
          setState(() {
            if (selectedKeywordIndex == index) {
              selectedKeywordIndex = -1;
              keyword[index]['isSelected'] = false;
              selectedKeyword = '';
              if (keyword[index]['keyword'] == '임시 휴무' ||
                  keyword[index]['keyword'] == 'EVENT' ||
                  keyword[index]['keyword'] == 'SALE') {
                showPeriod = false;
              } else {
                showPeriod = false;
              }
            } else {
              if (selectedKeywordIndex != -1)
                keyword[selectedKeywordIndex]['isSelected'] = false;

              selectedKeywordIndex = index;
              keyword[index]['isSelected'] = true;
              selectedKeyword = keyword[index]['keyword'];

              if (selectedKeyword == '임시 휴무' ||
                  selectedKeyword == 'EVENT' ||
                  selectedKeyword == 'SALE') {
                showPeriod = true;
              } else {
                showPeriod = false;
              }
            }
          });
        },
        elevation: 10,
      ),
    );
  }

  int selectedTypeIndex = -1;
  Widget buildType(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: 70,
          child: Align(
            alignment: Alignment.center,
            child: Text(type[index]['type'],
                style: TextStyle(
                  color: type[index]['isSelected']
                      ? Colors.white
                      : Color(0xff404040),
                  fontSize: 10,
                )),
          ),
        ),
        selected: selectedTypeIndex == index,
        selectedColor: Color(0xff03AA5A),
        backgroundColor: Color(0xffF2F2F2),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
        onSelected: (value) {
          setState(() {
            if (selectedTypeIndex == index) {
              selectedTypeIndex = -1;
              type[index]['isSelected'] = false;
              selectedType = '';
            } else {
              if (selectedTypeIndex != -1)
                type[selectedTypeIndex]['isSelected'] = false;

              selectedTypeIndex = index;
              type[index]['isSelected'] = true;
              selectedType = type[index]['type'];
            }
          });
        },
        elevation: 10,
      ),
    );
  }

  Widget caution() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '소식글 생성 시 주의 사항',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '- 할인율, 이벤트 날짜, 위치 등 구체적인 정보를 제공해 주세요.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            '- 추가/강조하고 싶은 내용을 작성해 주시면 가게에 더욱 맞춤화된 글을 작성해드릴 수 있어요!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            '- NeighClova는 광고 및 마케팅과 관련된 법률을 준수합니다. 허위 사실 또는 과장 광고는 피해주세요.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            '- AI가 생성한 내용을 항상 먼저 검토하고 필요에 따라 수정하세요!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
