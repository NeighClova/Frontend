import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_neighclova/tabview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_neighclova/place/place_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neighclova/auth_dio.dart';

class RegisterInfo extends StatefulWidget {
  const RegisterInfo({Key? key}) : super(key: key);

  @override
  State<RegisterInfo> createState() => _RegisterInfo();
}

class _RegisterInfo extends State<RegisterInfo> {
  TextEditingController placeName = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController placeUrl = TextEditingController();
  List<String> selectedAges = [];
  List<String> selectedTargets = [];
  String? placeNum = '';
  bool isChecked = false;
  bool isLoading = false;

  static final storage = FlutterSecureStorage();
  dynamic isFirst = '';
  dynamic email = '';

  final List<Map<String, dynamic>> targetAges = [
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

  Future<bool> savePlaceAction(placeName, category, placeUrl, selectedAges,
      selectedTargets, placeNum) async {
    try {
      var dio = await authDio(context);

      var body = {
        "placeName": placeName,
        "category": category,
        "targetAge": selectedAges,
        "target": selectedTargets,
        "placeUrl": placeUrl,
        "placeNum": placeNum
      };
      Response response = await dio.post('/place', data: body);

      if (response.statusCode == 200) {
        print('업체 정보 등록 완료');
        return true;
      } else if (response.statusCode == 401) {
        print('이메일 인증 코드 불일치');
        return false;
      } else {
        print('error: ${response.statusCode}');
        return false;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('HTTP error: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Exception: $e');
      }
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  searchPlaceUrl(placeUrl) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.env['BASE_URL_FAST']!;

    setState(() {
      isLoading = true; // 조회 시작, 로딩 상태로 변경
    });

    try {
      var body = {"place_url": placeUrl};

      Response response = await dio.post('/', data: body);

      if (response.statusCode == 200) {
        placeNum = PlaceNumResponse.fromJson(response.data).placeNum;

        if (placeNum != null) {
          showSnackBar(context, Text('인증되었습니다.'));
          setState(() {
            placeNum = PlaceNumResponse.fromJson(response.data).placeNum;
            isChecked = true;
            isLoading = false;
          });
        } else {
          showSnackBar(context, Text('유효하지 않은 스마트 플레이스 주소입니다.'));
          setState(() {
            isLoading = false;
          });
        }
      } else {
        showSnackBar(context, Text('유효하지 않은 스마트 플레이스 주소입니다.'));
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      // 오류 발생 시 팝업 표시
      showSnackBar(context, Text('오류가 발생했습니다.'));
      setState(() {
        isLoading = false;
      });
    }
  }

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
        title: Text('업체 정보 등록',
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
              onPressed: () async {
                if (placeUrl.text == '' || placeName.text == '') {
                  showSnackBar(context, Text('필수 정보를 입력해주세요.'));
                } else if (!isChecked) {
                  showSnackBar(
                      context, Text('스마트 플레이스 주소 조회가 되지 않았습니다. 다시 조회해주세요.'));
                } else {
                  //데이터 저장
                  Future<bool> result = savePlaceAction(
                      placeName.text,
                      category.text,
                      placeUrl.text,
                      selectedAges,
                      selectedTargets,
                      placeNum);
                  if (await result) {
                    //등록 여부 저장
                    email = await storage.read(key: 'email');
                    await storage.write(
                      key: email + 'First',
                      value: 'false',
                    );
                    // 메인 페이지로 이동
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => TabView(),
                        ),
                        (route) => false);
                  }
                }
              },
              child: Text(
                '저장',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff03AA5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
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
                        Text(
                          '매장명 *',
                          style:
                              TextStyle(color: Color(0xff717171), fontSize: 16),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        TextField(
                          controller: placeName,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            isDense: true,
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
                            )),
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
                        Text(
                          '업종',
                          style:
                              TextStyle(color: Color(0xff717171), fontSize: 16),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        TextField(
                          controller: category,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
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
                        Text(
                          '타겟 연령대',
                          style:
                              TextStyle(color: Color(0xff717171), fontSize: 16),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(targetAges.length, (index) {
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
                        Text(
                          '타겟 대상',
                          style:
                              TextStyle(color: Color(0xff717171), fontSize: 16),
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
                // 스마트 플레이스 주소와 조회하기 버튼
                Container(
                  height: 110,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '스마트 플레이스 주소 *',
                              style: TextStyle(
                                  color: Color(0xff717171), fontSize: 16),
                            ),
                            SizedBox(width: 10),
                            // 상태에 따른 이모티콘 표시
                            // 로딩 중
                            if (isLoading)
                              SizedBox(
                                width: 20, // 너비 조절
                                height: 20, // 높이 조절
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0, // 원의 두께 조절
                                ),
                              )
                            else if (isChecked == true)
                              Icon(Icons.check_circle,
                                  color: Colors.green) // 성공 시 초록색 체크
                            else if (isChecked == false)
                              Icon(Icons.error,
                                  color: Colors.red), // 실패 시 빨간색 X
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            // URL 입력 필드
                            Expanded(
                              child: TextField(
                                controller: placeUrl,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
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
                                  hintText: 'https://naver.',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400], // 더 연한 회색으로 설정
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // 조회하기 버튼
                            ElevatedButton(
                              onPressed: () {
                                searchPlaceUrl(placeUrl.text);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff03AA5A),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: Text(
                                '조회하기',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
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
            child: Text(targets[index]['target'],
                style: TextStyle(
                  color: targets[index]['isSelected']
                      ? Colors.white
                      : Color(0xff404040),
                  fontSize: 12,
                )),
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
            //추가된 부분
            if (targets[index]['isSelected']) {
              selectedTargets.add(targets[index]['target']);
            } else {
              selectedTargets.remove(targets[index]['target']);
            }
          });
        },
        elevation: 0,
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
            child: Text(targetAges[index]['age'],
                style: TextStyle(
                  color: targetAges[index]['isSelected']
                      ? Colors.white
                      : Colors.black,
                  fontSize: 12,
                )),
          ),
        ),
        selected: targetAges[index]['isSelected'],
        selectedColor: Color(0xff03AA5A),
        backgroundColor: Color(0xffF2F2F2),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.transparent),
        ),
        onSelected: (value) {
          setState(() {
            targetAges[index]['isSelected'] = !targetAges[index]['isSelected'];
            //추가된 부분
            if (targetAges[index]['isSelected']) {
              selectedAges.add(targetAges[index]['age']);
            } else {
              selectedAges.remove(targetAges[index]['age']);
            }
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
