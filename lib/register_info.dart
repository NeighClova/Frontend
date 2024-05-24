import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/main_page.dart';

class RegisterInfo extends StatefulWidget {
	const RegisterInfo({Key? key}) : super(key: key);

  @override
  State<RegisterInfo> createState() => _RegisterInfo();
}

class _RegisterInfo extends State<RegisterInfo> {

  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();

  final List<Map<String, dynamic>> ages = [
    {'age': '10대', 'isSelected': false},
    {'age': '20대', 'isSelected': false},
    {'age': '30대', 'isSelected': false},
    {'age': '40대', 'isSelected': false},
    {'age': '50대', 'isSelected': false},
    {'age': '60대 이상', 'isSelected': false},
  ];
  final List<Map<String, dynamic>> targets = [
    {'target': '학생', 'isSelected': false},
    {'target': '지역 주민', 'isSelected': false},
    {'target': '회사원', 'isSelected': false},
    {'target': '가족', 'isSelected': false},
    {'target': '관광객', 'isSelected': false},
    {'target': '여성', 'isSelected': false},
    {'target': '남성', 'isSelected': false},
  ];

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
        title: Text('업체 정보 등록',
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
              if (controller3.text == '')
              {
                showSnackBar(context, Text('필수 정보를 입력해주세요.'));
              }
              else
              {
                //데이터 저장
                //등록 여부 저장하기
                //메인페이지로 이동
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                    MainPage(),
                  ), (route) => false
                );
              }
              print('업체정보 데이터 전달');
            },
            child: Text('저장',
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
          child: Column(
            children: [
              //매장명
              Container(
                height: 110,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 추가됨
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('매장명',
                        style: TextStyle(
                          color: Color(0xff717171),
                          fontSize: 16
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //업종
              Container(
                height: 110,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 추가됨
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('업종',
                        style: TextStyle(
                          color: Color(0xff717171),
                          fontSize: 16
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      TextField(
                        controller: controller2,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
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
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //타겟 연령대
              Container(
                height: 100,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 추가됨
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('타겟 연령대',
                        style: TextStyle(
                          color: Color(0xff717171),
                          fontSize: 16
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(ages.length, (index) {
                            return buildAgeChips(index);
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //타겟 대상
              Container(
                height: 100,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 추가됨
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('타겟 대상',
                        style: TextStyle(
                          color: Color(0xff717171),
                          fontSize: 16
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(targets.length, (index) {
                            return buildTargetChips(index);
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //스마트 플레이스 주소
              Container(
                height: 110,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 추가됨
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('스마트 플레이스 주소 *',
                        style: TextStyle(
                          color: Color(0xff717171),
                          fontSize: 16
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      TextField(
                        controller: controller3,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
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
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
		);
	}

  Widget buildAgeChips(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              ages[index]['age'],
              style: TextStyle(
              color: ages[index]['isSelected'] ? Colors.white : Colors.black,
              fontSize: 12,
              )
            ),
          ),
        ),
        selected: ages[index]['isSelected'],
        selectedColor: Color(0xff03AA5A),
        backgroundColor: Color(0xffF2F2F2),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
        onSelected: (value) {
          setState(() {
            ages[index]['isSelected'] = !ages[index]['isSelected'];
          });
        },
        elevation: 0,
      ),
    );
  }

  Widget buildTargetChips(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              targets[index]['target'],
              style: TextStyle(
              color: targets[index]['isSelected'] ? Colors.white : Color(0xff404040),
              fontSize: 12,
              )
            ),
          ),
        ),
        selected: targets[index]['isSelected'],
        selectedColor: Color(0xff03AA5A),
        backgroundColor: Color(0xffF2F2F2),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
        onSelected: (value) {
          setState(() {
            targets[index]['isSelected'] = !targets[index]['isSelected'];
          });
        },
        elevation: 0,
      ),
    );
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Color(0xff03C75A),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}