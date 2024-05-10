import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
    initAmPm = initialTime.hour >= 12 && initialTime.hour < 24 ? "오후" : "오전";
    initHour = initialTime.hour > 12 && initialTime.hour <= 24 ? initialTime.hour - 12 : initialTime.hour;
      if (initHour == 0)
        initHour = 12;
    finalAmPm = fianlTime.hour >= 12 && fianlTime.hour < 24 ? "오후" : "오전";
    finalHour = fianlTime.hour > 12 && fianlTime.hour <= 24 ? fianlTime.hour - 12 : fianlTime.hour;
      if (finalHour == 0)
        finalHour = 12;
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
  TimeOfDay fianlTime = TimeOfDay.now();

  @override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          )
        ),
        title: Text('소식 생성',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          )
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Padding(padding: EdgeInsets.only(top: 10)),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  /////////////////////////////////
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
                                color:Colors.black,
                                fontSize: 20,
                              )
                            ),
                            Text('어떤 소식을 작성하시겠어요?',
                              style: TextStyle(
                                color:Colors.grey,
                                fontSize: 15,
                              )
                            ),
                          ]
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
                          textStyle: TextStyle(color: Colors.black),
                          preferBelow: false,
                          verticalOffset: 15,
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(keyword.length, (index) {
                        return buildKeyword(index);
                      }),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('소식 유형',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text('구체적으로 어떤 종류의 소식을 작성하시겠어요?',
                            style: TextStyle(
                              color:Colors.grey,
                              fontSize: 15,
                            )
                          ),
                        ]
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(type.length, (index) {
                        return buildType(index);
                      }),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      minLines: 2,
                      maxLines: 5,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '추가로 원하는 소식의 유형을 작성해주세요.',
                        enabledBorder: OutlineInputBorder(
                          borderSide:BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )
                        )
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('기간',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text('특별 이벤트나 세일의 유효 기간 등을 작성해주세요.',
                            style: TextStyle(
                              color:Colors.grey,
                              fontSize: 15,
                            )
                          ),
                        ]
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                                onPressed: () async {
                                  final DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: initialDay,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(3000)
                                  );
                                  if (dateTime != null) {
                                    setState(() {
                                      initialDay = dateTime;
                                    });
                                  }
                                },
                                child: Text('${initialDay.month}월 ${initialDay.day}일 (${DateFormat('E', 'ko_KR').format(initialDay)})')
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: initHour, minute: initialTime.minute),
                                  );
                                  if (timeOfDay != null) {
                                    setState(() {
                                      initialTime = timeOfDay;
                                      initAmPm = initialTime.hour >= 12 && initialTime.hour < 24 ? "오후" : "오전";
                                      initHour = initialTime.hour > 12 && initialTime.hour <= 24 ? initialTime.hour - 12 : initialTime.hour;
                                      if (initHour == 0)
                                        initHour = 12;
                                    });
                                  }
                                },
                                child: Text('${initAmPm} ${initHour}:${initialTime.minute}')
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 20)),
                        Container(
                          child: Icon(Icons.arrow_forward, size: 40, color: Colors.black,),
                        ),
                        Padding(padding: EdgeInsets.only(right: 20)),
                        Container(
                          child: Column(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                                onPressed: () async {
                                  final DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: finalDay,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(3000)
                                  );
                                  if (dateTime != null) {
                                    setState(() {
                                      finalDay = dateTime;
                                    });
                                  }
                                },
                                child: Text('${finalDay.month}월 ${finalDay.day}일 (${DateFormat('E', 'ko_KR').format(finalDay)})')
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: finalHour, minute: fianlTime.minute),
                                  );
                                  if (timeOfDay != null) {
                                    setState(() {
                                      fianlTime = timeOfDay;
                                      finalAmPm = fianlTime.hour >= 12 && fianlTime.hour < 24 ? "오후" : "오전";
                                      finalHour = fianlTime.hour > 12 && fianlTime.hour <= 24 ? fianlTime.hour - 12 : initialTime.hour;
                                      if (finalHour == 0)
                                        finalHour = 12;
                                    });
                                  }
                                },
                                child: Text('${finalAmPm} ${finalHour}:${fianlTime.minute}')
                              ),
                            ],
                          ),
                        ),
                      ], 
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child : Text('강조하고 싶은 내용 추가',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    TextFormField(
                      minLines: 3,
                      maxLines: 5,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '추가/강조하고 싶은 내용을 작성해주세요.',
                        enabledBorder: OutlineInputBorder(
                          borderSide:BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ]
          )
        )
      )
		);
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
            child: Text(
              keyword[index]['keyword'],
              style: TextStyle(
              color: keyword[index]['isSelected'] ? Colors.white : Colors.black,
              fontSize: 11,
              )
            ),
          ),
        ),
        selected: selectedKeywordIndex == index,
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
            }
            else {
              selectedKeywordIndex = index;
            }
            for (int i = 0; i < keyword.length; i++) {
              if (i != index) {
                keyword[i]['isSelected'] = false;
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
            child: Text(
              type[index]['type'],
              style: TextStyle(
              color: type[index]['isSelected'] ? Colors.white : Colors.black,
              fontSize: 10,
              )
            ),
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
            }
            else {
              selectedTypeIndex = index;
            }
            for (int i = 0; i < type.length; i++) {
              if (i != index) {
                type[i]['isSelected'] = false;
              }
            }
          });
        },
        elevation: 10,
      ),
    );
  }
}