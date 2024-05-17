import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/change_password.dart';
import 'package:flutter_neighclova/edit_info.dart';
import 'package:flutter_neighclova/license.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:image_picker/image_picker.dart';

class MyPage extends StatefulWidget {
	const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final picker = ImagePicker();
  XFile? _pickedFile; //프로필 이미지 저장
  final _imageSize = 60.0;
  final String username = '아이디';

  @override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          )
        ),
        title: Text('마이페이지',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          )
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
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
                        if (_pickedFile == null)
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: _imageSize,
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
                                    image: FileImage(File(_pickedFile!.path)),
                                    fit: BoxFit.cover
                                  )
                                ),
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
                                  '식당 이름',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  '업종',
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
                              '플레이스 주소',
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
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  EditInfo())
                              );
                          },
                          child: const Text('수정',
                            style: TextStyle(color: Color(0xff03AA5A), fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(3),
                            side: BorderSide(color: Color(0xff03AA5A), width: 1),
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
            )
          ),
          Container(
            height: 250,
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
                              color: Colors.black,
                              size: 30,
                            ),
                            Padding(padding: EdgeInsets.only(right: 15)),
                            Text(username,
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
                          child: Text('아이디',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xff949494),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  Divider(thickness: 0.5, height: 1, color: Color(0xffBCBCBC),),
                  //비밀번호 변경
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.key,
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
                                    ChangePassword())
                                );
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                shadowColor: MaterialStateProperty.all(Colors.transparent),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                minimumSize: MaterialStateProperty.all(Size.fromHeight(70)),
                                padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
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
                  Divider(thickness: 0.5, height: 1, color: Color(0xffBCBCBC),),                  //로그아웃
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.logout,
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      backgroundColor: Colors.white,
                                      title: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text('로그아웃'),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text('로그아웃 하시겠어요?'),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            new TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.black,
                                              ),
                                              child: Text('    취소')
                                            ),
                                            new TextButton(
                                              onPressed: () {
                                                print('로그아웃');
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                    Login(),
                                                  ), (route) => false
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                              child: Text('로그아웃')
                                            ),
                                          ],
                                        )
                                        
                                      ],
                                    );
                                  }
                                );
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                shadowColor: MaterialStateProperty.all(Colors.transparent),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                minimumSize: MaterialStateProperty.all(Size.fromHeight(70)),
                                padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
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
                  Divider(thickness: 0.5, height: 1, color: Color(0xffBCBCBC),),
                  //회원탈퇴
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_remove_outlined,
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      backgroundColor: Colors.white,
                                      title: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text('회원 탈퇴'),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            style: TextStyle(color: Colors.black),
                                            children: [
                                              TextSpan(text: '계정이 삭제된 후에는 복구가 '),
                                              TextSpan(
                                                text: '불가능',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                              TextSpan(text: '합니다.\n정말로 탈퇴하시겠어요?'),
                                            ],
                                          ),
                                        ),]
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            new TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.black,
                                              ),
                                              child: Text('    취소')
                                            ),
                                            new TextButton(
                                              onPressed: () {
                                                print('회원 탈퇴');
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                    Login(),
                                                  ), (route) => false
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                              child: Text('탈퇴하기')
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  }
                                );
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                shadowColor: MaterialStateProperty.all(Colors.transparent),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                minimumSize: MaterialStateProperty.all(Size.fromHeight(70)),
                                padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
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
                                  License()
                                )
                              );
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                              shadowColor: MaterialStateProperty.all(Colors.transparent),
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                              minimumSize: MaterialStateProperty.all(Size.fromHeight(70)),
                              padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
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
                  Divider(thickness: 0.5, height: 1, color: Color(0xffBCBCBC),),                  //로그아웃
                  //개인정보 처리방침 및 이용약관
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
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
                                print('개인정보 처리방침 및 이용약관 링크 이동');
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                shadowColor: MaterialStateProperty.all(Colors.transparent),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                minimumSize: MaterialStateProperty.all(Size.fromHeight(70)),
                                padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
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
              )
            )
          )
        ]
      )
		);
	}

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
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
                foregroundColor: MaterialStateProperty.all(Colors.black),
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
                  foregroundColor: MaterialStateProperty.all(Colors.black),
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
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
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
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
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