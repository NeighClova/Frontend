import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/introduction.dart';

class GenerateIntroduction extends StatefulWidget {
	const GenerateIntroduction({Key? key}) : super(key: key);

  @override
  State<GenerateIntroduction> createState() => _GenerateIntroductionState();
}

class _GenerateIntroductionState extends State<GenerateIntroduction> {
  
  var _generatedText = '생성된 소개글';
  TextEditingController controller = TextEditingController();
  final List<Map<String, dynamic>> purpose = [
    {'keyword': '데이트', 'isSelected': false},
    {'keyword': '가족모임', 'isSelected': false},
    {'keyword': '상견례', 'isSelected': false},
    {'keyword': '파티', 'isSelected': false},
    {'keyword': '회식', 'isSelected': false},
    {'keyword': '기념일', 'isSelected': false},
    {'keyword': '비즈니스미팅', 'isSelected': false},
  ];
  final List<Map<String, dynamic>> service = [
    {'keyword': '단체석', 'isSelected': false},
    {'keyword': '룸', 'isSelected': false},
    {'keyword': '카운터석', 'isSelected': false},
    {'keyword': '좌식', 'isSelected': false},
    {'keyword': '입식', 'isSelected': false},
    {'keyword': '테라스', 'isSelected': false},
    {'keyword': '연인석', 'isSelected': false},
    {'keyword': '루프탑', 'isSelected': false},
    {'keyword': '1인석', 'isSelected': false},
    {'keyword': '주차공간', 'isSelected': false},
    {'keyword': '애견동반', 'isSelected': false},
    {'keyword': '발렛파킹', 'isSelected': false},
  ];
  final List<Map<String, dynamic>> mood = [
    {'keyword': '분위기좋은', 'isSelected': false},
    {'keyword': '혼밥', 'isSelected': false},
    {'keyword': '혼술', 'isSelected': false},
    {'keyword': '대화하기 좋은', 'isSelected': false},
    {'keyword': '조용한', 'isSelected': false},
    {'keyword': '이국적인', 'isSelected': false},
    {'keyword': '편한좌석', 'isSelected': false},
  ];

  @override
	Widget build(BuildContext context) {
		return Scaffold(
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
          )
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: ElevatedButton(
            onPressed: () {
              //////////////////////////데이터 전달
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (BuildContext context, StateSetter bottomState) {
                    return Container(
                      height: 600,
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
                            child: Text('선택된 키워드를 기반으로\n소개글을 생성했어요!',
                              style: TextStyle(fontSize: 18, color: Color(0xff404040), fontWeight: FontWeight.bold,),
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
                                  child: Text(_generatedText,
                                    style: TextStyle(fontSize: 15, color: Color(0xff404040)),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xffF2F2F2),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                    )
                                  ],
                                ),
                              )
                            ),
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
                                      builder: (context) => GenerateIntroduction()
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffF2F2F2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(130, 50),
                                ),
                                child: Text('재생성',
                                  style: TextStyle(fontSize: 17, color: Color(0xff404040)),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 10)),
                              ElevatedButton(
                                onPressed: () {
                                  //////////////////////////DB 저장
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Introduction()
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff03AA5A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(230, 50),
                                ),
                                child: Text('적용하기',
                                  style: TextStyle(fontSize: 17, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                }
              );
            },
            child: Text('키워드 기반 맞춤 소개 글 생성하기',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff03AA5A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
          ),
        ),
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
                    color:Color(0xff404040),
                    fontSize: 20,
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 25)),
                Text('방문 목적',
                  style: TextStyle(
                    color:Color(0xff656565),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                ),
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
                    color:Color(0xff656565),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                ),
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
                    color:Color(0xff656565),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                ),
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
                    color:Color(0xff656565),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 14)),
                TextFormField(
                      controller: controller,
                      minLines: 3,
                      maxLines: 5,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        isDense: true,
                        hintText: '추천 메뉴나 맛 설명 등 추가/강조하고 싶은 내용을 작성해주세요.\n예)인기 메뉴 마라 쌀국수, 과하지 않은 향신료로 이국적이면서도 부담스럽지 않은 맛',
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
        )
      )
		);
	}

  Widget buildPurposeChips(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: purpose[index]['keyword'].length * 15.0,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              purpose[index]['keyword'],
              style: TextStyle(
              color: purpose[index]['isSelected'] ? Colors.white : Colors.black,
              fontSize: 12,
              )
            ),
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
          width: service[index]['keyword'].length * 15.0,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              service[index]['keyword'],
              style: TextStyle(
              color: service[index]['isSelected'] ? Colors.white : Colors.black,
              fontSize: 12,
              )
            ),
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
          width: mood[index]['keyword'].length * 15.0,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              mood[index]['keyword'],
              style: TextStyle(
              color: mood[index]['isSelected'] ? Colors.white : Colors.black,
              fontSize: 12,
              )
            ),
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
          });
        },
        elevation: 0,
      ),
    );
  }
}