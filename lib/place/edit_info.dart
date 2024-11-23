import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_neighclova/place/place_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neighclova/auth_dio.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({Key? key}) : super(key: key);

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  static final storage = FlutterSecureStorage();
  dynamic place;
  dynamic placeId;

  bool isChecked = false;
  bool isLoading = false;
  String? placeNum = '';

  TextEditingController placeNameText = TextEditingController();
  TextEditingController categoryText = TextEditingController();
  TextEditingController placeUrlText = TextEditingController();
  List<String> selectedAges = [];
  List<String> selectedTargets = [];

  List<Map<String, dynamic>> ages = [
    {'age': '10대', 'isSelected': false},
    {'age': '20대', 'isSelected': false},
    {'age': '30대', 'isSelected': false},
    {'age': '40대', 'isSelected': false},
    {'age': '50대', 'isSelected': false},
    {'age': '60대 이상', 'isSelected': false},
  ];
  List<Map<String, dynamic>> targets = [
    {'target': '학생', 'isSelected': false},
    {'target': '지역 주민', 'isSelected': false},
    {'target': '회사원', 'isSelected': false},
    {'target': '가족', 'isSelected': false},
    {'target': '관광객', 'isSelected': false},
    {'target': '여성', 'isSelected': false},
    {'target': '남성', 'isSelected': false},
  ];

  getPlaceInfo() async {
    var dio = await authDio(context);
    placeId = await storage.read(key: 'placeId');

    Map<String, dynamic> queryParams = {
      'placeId': placeId,
    };

    try {
      Response response = await dio.get('/place', queryParameters: queryParams);
      if (response.statusCode == 200) {
        setState(() {
          place = Place.fromJson(response.data);
        });

        for (var age in ages) {
          if (place.targetAge.contains(age['age'])) {
            age['isSelected'] = true;
            selectedAges.add(age['age']);
          }
        }
        for (var target in targets) {
          if (place.target.contains(target['target'])) {
            target['isSelected'] = true;
            selectedTargets.add(target['target']);
          }
        }

        setState(() {
          place = Place.fromJson(response.data);
          ages = ages;
          targets = targets;
          selectedTargets = selectedTargets;
          selectedAges = selectedAges;
          placeNameText = TextEditingController(text: (place?.placeName ?? ''));
          categoryText = TextEditingController(text: (place?.category ?? ''));
          placeUrlText = TextEditingController(text: (place?.placeUrl ?? ''));
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  patchPlaceAction(selectedAges, selectedTargets, placeNum) async {
    print(selectedAges);
    print(selectedTargets);
    try {
      var body = {
        "placeName": placeNameText.text,
        "category": categoryText.text,
        "targetAge": selectedAges,
        "target": selectedTargets,
        "placeUrl": placeUrlText.text,
        "placeNum": placeNum
      };

      var dio = await authDio(context);
      Map<String, dynamic> queryParams = {
        'placeId': placeId,
      };

      Response response =
          await dio.patch('/place', data: body, queryParameters: queryParams);

      if (response.statusCode == 200) {
        print('patch success');
      } else if (response.statusCode == 401) {
        print('forbiden');
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
    var dio = await authDio(context);
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
  void initState() {
    super.initState();
    getPlaceInfo();
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
        title: Text('업체 정보 수정',
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
              onPressed: () {
                if (placeUrlText.text == '' || placeNameText.text == '') {
                  showSnackBar(context, Text('필수 정보를 입력해주세요.'));
                } else if (!isChecked) {
                  showSnackBar(
                      context, Text('스마트 플레이스 주소 조회가 되지 않았습니다. 다시 조회해주세요.'));
                } else {
                  patchPlaceAction(selectedAges, selectedTargets, placeNum);
                  Navigator.pop(context, true);
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '매장명 *',
                          style:
                              TextStyle(color: Color(0xff717171), fontSize: 16),
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        TextField(
                          controller: placeNameText,
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
                          controller: categoryText,
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
                                controller: placeUrlText,
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
                                searchPlaceUrl(placeUrlText.text);
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

  Widget buildAgeChips(index) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ChoiceChip(
        labelPadding: EdgeInsets.all(0),
        label: SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.center,
            child: Text(ages[index]['age'],
                style: TextStyle(
                  color:
                      ages[index]['isSelected'] ? Colors.white : Colors.black,
                  fontSize: 12,
                )),
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
            //추가된 부분
            if (ages[index]['isSelected']) {
              selectedAges.add(ages[index]['age']);
            } else {
              selectedAges.remove(ages[index]['age']);
            }
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
            child: Text(targets[index]['target'],
                style: TextStyle(
                  color: targets[index]['isSelected']
                      ? Colors.white
                      : Colors.black,
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
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Color(0xff03C75A),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
