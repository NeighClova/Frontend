import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neighclova/auth/change_password_page.dart';
import 'package:flutter_neighclova/auth/check_password_page.dart';
import 'package:flutter_neighclova/mypage/instagram_register.dart';
import 'package:flutter_neighclova/place/edit_info.dart';
import 'package:flutter_neighclova/mypage/license.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:flutter_neighclova/place/place_response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_neighclova/auth_dio.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final picker = ImagePicker();
  dynamic sendData;
  XFile? _pickedFile; //프로필 이미지 저장
  final _imageSize = 60.0;
  static final storage = FlutterSecureStorage();
  dynamic accesstoken = '';
  dynamic placeId;
  dynamic place;
  dynamic email = '';
  dynamic IGName = '';
  String id = '';

  @override
  void initState() {
    super.initState();
    getPlaceInfo();
    getEmail();
    _initialize();
  }

  Future<void> getEmail() async {
    String? storedEmail = await storage.read(key: 'email');
    setState(() {
      email = storedEmail ?? '';
    });
  }

  Future<void> _initialize() async {
    await getPlaceId();
    print('getName 실행');
    await getIGName(); // 이 작업이 완료될 때까지 기다림
  }

  Future<void> getIGName() async {
    String? storedIGName = await storage.read(key: placeId + 'IGName');
    setState(() {
      IGName = storedIGName ?? '';
    });
    print('IGName : $IGName');
  }

  Future<void> getPlaceId() async {
    String? storedPlaceId = await storage.read(key: 'placeId');
    setState(() {
      placeId = storedPlaceId ?? '';
    });
  }

  void _fetchMyInfo() async {
    await Future.delayed(Duration(seconds: 1));
    getPlaceInfo();
  }

  Future<void> patchImg(String filePath) async {
    var dio = await authDio(context);

    String? placeId = await storage.read(key: 'placeId');
    MultipartFile img = await MultipartFile.fromFile(filePath);

    // FormData 생성
    FormData formData = FormData.fromMap({
      'file': img,
    });

    // 파라미터 설정
    Map<String, dynamic> queryParams = {
      'placeId': placeId,
    };

    // PATCH 요청 보내기
    try {
      Response response = await dio.patch('/place/img',
          queryParameters: queryParams, data: formData);
      if (response.statusCode == 200) {
        // 성공적인 응답 처리
        print('이미지 업로드 성공');
      } else {
        // 200이 아닌 응답 처리
        print('이미지 업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 오류 처리
      print('이미지 업로드 중 오류 발생: $e');
    }
  }

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
        print(place?.placeName);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  deleteAction() async {
    var dio = await authDio(context);

    try {
      Response response = await dio.patch('/auth/delete');

      if (response.statusCode == 200) {
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'refreshToken');
        await storage.delete(key: 'password');
        await storage.delete(key: 'id');
        await storage.delete(key: 'email');
        await storage.delete(key: 'placeId');
        print('탈퇴 완료');
        return;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
          title: Text('마이페이지',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff404040),
                fontSize: 20,
              )),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xff949494), width: 1),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (place?.profileImg == null)
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipOval(
                                  child: Container(
                                      width: _imageSize,
                                      height: _imageSize,
                                      color: Color.fromRGBO(161, 182, 233, 1),
                                      child: _pickedFile == null
                                          ? Icon(Icons.person,
                                              color: Colors.white,
                                              size: _imageSize - 20)
                                          : Image.file(
                                              File(_pickedFile!.path),
                                              fit: BoxFit.cover,
                                            )),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minHeight: 30,
                                      minWidth: 30,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff656565),
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showBottomSheet();
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: _imageSize,
                                  height: _imageSize,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: (_pickedFile == null)
                                              ? NetworkImage(
                                                      '${place?.profileImg}')
                                                  as ImageProvider<Object>
                                              : FileImage(
                                                  File(_pickedFile!.path)),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minHeight: 30,
                                      minWidth: 30,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff656565),
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showBottomSheet();
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Padding(padding: EdgeInsets.only(left: 15)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center, // 추가됨
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    place?.placeName ?? '',
                                    style: TextStyle(
                                      color: Color(0xff404040),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    place?.category ?? '',
                                    style: TextStyle(
                                      color: Color(0xff949494),
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                place?.placeUrl ?? '',
                                style: TextStyle(
                                  color: Color(0xff717171),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // 수정버튼 자리
                      SizedBox(
                        width: 50,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditInfo()));
                              if (result == true) {
                                _fetchMyInfo();
                              }
                            },
                            child: const Text('수정',
                                style: TextStyle(
                                    color: Color(0xff03AA5A), fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                              side: BorderSide(
                                  color: Color(0xff03AA5A), width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: Size(50, 30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xff949494), width: 1),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //아이디
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 55,
                        width: 150,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: Color(0xff404040),
                              size: 30,
                            ),
                            Padding(padding: EdgeInsets.only(right: 15)),
                            Text(
                              '아이디',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerRight,
                        height: 55,
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff949494),
                          ),
                        ),
                      )),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    color: Color(0xffBCBCBC),
                  ),
                  //비밀번호 변경
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.key,
                        color: Color(0xff404040),
                        size: 30,
                      ),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CheckPasswordPage()));
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Color(0xff404040)),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              minimumSize: MaterialStateProperty.all(
                                  Size.fromHeight(70)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.only(left: 0)),
                              alignment: Alignment.centerLeft,
                              textStyle: MaterialStateProperty.all(
                                TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            child: Text('비밀번호 변경'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    color: Color(0xffBCBCBC),
                  ),
                  //인스타
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 55,
                        width: 200,
                        child: Row(
                          children: [
                            Image.asset('assets/insta_black.png',
                                width: 30, height: 30),
                            Padding(padding: EdgeInsets.only(right: 15)),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 55,
                                child: TextButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                InstagramRegister()));
                                    if (result == true) {
                                      await getIGName();
                                      setState(() {});
                                    }
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                        Color(0xff404040)),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    minimumSize: MaterialStateProperty.all(
                                        Size.fromHeight(70)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.only(left: 0)),
                                    alignment: Alignment.centerLeft,
                                    textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  child: Text('인스타그램 계정 연결'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerRight,
                        height: 55,
                        child: Text(
                          IGName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff949494),
                          ),
                        ),
                      )),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    color: Color(0xffBCBCBC),
                  ), //로그아웃
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Color(0xff404040),
                        size: 30,
                      ),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      insetPadding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      title: Text(
                                        '로그아웃',
                                        textAlign: TextAlign.center,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      actionsPadding: EdgeInsets.zero,
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              '로그아웃 하시겠어요?',
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 20),
                                          ]),
                                      actions: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              child: Divider(
                                                  height: 1,
                                                  color: Colors.grey),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Center(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor:
                                                            Color(0xff404040),
                                                      ),
                                                      child: Text(
                                                        '취소',
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                )),
                                                Container(
                                                  height: 48,
                                                  width: 1,
                                                  color: Colors.grey,
                                                ),
                                                Expanded(
                                                    child: Center(
                                                  child: TextButton(
                                                      onPressed: () async {
                                                        await storage.delete(
                                                          key: 'accessToken');
                                                        await storage.delete(
                                                          key: 'placeId');
                                                        await storage.delete(
                                                          key: 'refreshToken');
                                                        await storage.delete(
                                                          key: 'password');
                                                        await storage.delete(
                                                          key: 'id');
                                                        await storage.delete(
                                                          key: 'email');
                                                        print('로그아웃');
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      Login(),
                                                                ),
                                                                (route) =>
                                                                    false);
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor:
                                                            Colors.red,
                                                      ),
                                                      child: Text(
                                                        '로그아웃',
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Color(0xff404040)),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              minimumSize: MaterialStateProperty.all(
                                  Size.fromHeight(70)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.only(left: 0)),
                              alignment: Alignment.centerLeft,
                              textStyle: MaterialStateProperty.all(
                                TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            child: Text('로그아웃'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    color: Color(0xffBCBCBC),
                  ),
                  //회원탈퇴
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_remove_outlined,
                        color: Color(0xff404040),
                        size: 30,
                      ),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      insetPadding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      title: Text(
                                        '회원 탈퇴',
                                        textAlign: TextAlign.center,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      actionsPadding: EdgeInsets.zero,
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 10),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color: Color(0xff404040)),
                                                children: [
                                                  TextSpan(
                                                      text: '계정이 삭제된 후에는 복구가 '),
                                                  TextSpan(
                                                    text: '불가능',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '합니다.\n정말로 탈퇴하시겠어요?'),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                          ]),
                                      actions: [
                                        Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                child: Divider(
                                                    height: 1,
                                                    color: Colors.grey),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Center(
                                                      child: TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Color(
                                                                    0xff404040),
                                                          ),
                                                          child: Text(
                                                            '취소',
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 48,
                                                    width: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  Expanded(
                                                      child: Center(
                                                    child: TextButton(
                                                        onPressed: () async {
                                                          deleteAction();
                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        Login(),
                                                                  ),
                                                                  (route) =>
                                                                      false);
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.red,
                                                        ),
                                                        child: Text(
                                                          '탈퇴하기',
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                  )),
                                                ],
                                              )
                                            ]),
                                      ],
                                    );
                                  });
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Color(0xff404040)),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              minimumSize: MaterialStateProperty.all(
                                  Size.fromHeight(70)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.only(left: 0)),
                              alignment: Alignment.centerLeft,
                              textStyle: MaterialStateProperty.all(
                                TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            child: Text('회원 탈퇴'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
              height: 140,
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //오픈소스 라이선스
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Colors.black,
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 15)),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 55,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              License()));
                                },
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(
                                      Color(0xff404040)),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  minimumSize: MaterialStateProperty.all(
                                      Size.fromHeight(70)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.only(left: 0)),
                                  alignment: Alignment.centerLeft,
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                child: Text('오픈소스 라이선스'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 0.5,
                        height: 1,
                        color: Color(0xffBCBCBC),
                      ), //로그아웃
                      //개인정보 처리방침 및 이용약관
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xff404040),
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 15)),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 55,
                              child: TextButton(
                                onPressed: () {
                                  print('개인정보 처리방침 및 이용약관 링크 이동');
                                  launchUrl(Uri.parse(
                                      'https://circular-hamster-14b.notion.site/f0af9a0c85fc4c87b7b5301bbbe41e75?pvs=4'));
                                },
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(
                                      Color(0xff404040)),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  minimumSize: MaterialStateProperty.all(
                                      Size.fromHeight(70)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.only(left: 0)),
                                  alignment: Alignment.centerLeft,
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                child: Text('개인정보 처리방침 및 이용약관'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )))
        ]));
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),*/
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _getCameraImage();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff404040)),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.center,
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                child: const Text('사진찍기'),
              ),
            ),
            const Divider(
              thickness: 3,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _getPhotoLibraryImage();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff404040)),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.center,
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                child: const Text('앨범에서 불러오기'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      sendData = pickedFile.path;
      patchImg(sendData);
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      sendData = pickedFile.path;
      patchImg(sendData);
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }
}
