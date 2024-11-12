import 'package:flutter/material.dart';
import 'package:flutter_neighclova/auth/change_password_page.dart';
import 'package:flutter_neighclova/auth/find_id_page.dart';
import 'package:flutter_neighclova/auth/find_password_page.dart';
import 'package:flutter_neighclova/auth/password_email_auth_page.dart';
import 'package:flutter_neighclova/main.dart';

class CheckPasswordPage extends StatefulWidget {
  const CheckPasswordPage({Key? key}) : super(key: key);

  @override
  State<CheckPasswordPage> createState() => _CheckPasswordPageState();
}

class _CheckPasswordPageState extends State<CheckPasswordPage> {
  TextEditingController controller = TextEditingController();
  String email= '';

  void _handleButtonPressed() {
    if (controller.text == 'password') {
      final id = 'testid';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ChangePasswordPage(email: email),
        ));
    } else {
      showSnackBar(context, Text('비밀번호가 옳지 않습니다.'));
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
            title: Text('비밀번호 찾기',
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
                child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 26, right: 26),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 25)),
                        Text(
                          '비밀번호 확인',
                          style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          '회원님의 정보 보호를 위해,',
                          style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '현재 사용중인 비밀번호를 확인해주세요.',
                          style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 14,
                          ),
                        ),
                      ]),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                padding: EdgeInsets.all(26.0),
                child: Center(
                  child:
                    Form(child: Container(child: Builder(builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        '비밀번호',
                        style: TextStyle(
                            color: Color(0xff717171), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          hintText: '비밀번호 입력',
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
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PasswordPage()));
                        },
                        child: Text(
                          '비밀번호를 잊으셨나요?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff949494),
                            fontSize: 13,
                            color: Color(0xff949494),
                          ),
                        ),
                      ),
                    ]);
                  }))),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
            ]))),
            bottomNavigationBar: SafeArea(
                child: Container(
                  height: 70,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: ElevatedButton(
                      onPressed: _handleButtonPressed,
                      child: Text(
                        '완료',
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

class PasswordUserdata {
  String id;
  String email;
  PasswordUserdata(this.id, this.email);
}