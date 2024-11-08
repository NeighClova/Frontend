import 'package:flutter/material.dart';
import 'package:flutter_neighclova/auth/find_id_page.dart';
import 'package:flutter_neighclova/auth/password_email_auth_page.dart';
import 'package:flutter_neighclova/main.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  TextEditingController controller = TextEditingController();

  void _handleButtonPressed() {
    if (controller.text == 'testid') {
      final email = 'sojin49@naver.com';
      final userdata = PasswordUserdata(controller.text, email);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              PasswordEmailAuthPage(userdata: userdata),
        ));
    } else {
      showSnackBar(context, Text('가입되지 않은 아이디입니다.'));
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
                          '• 회원님의 아이디를 입력해주세요.',
                          style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '• 회원가입 시 입력했던 이메일로 인증 코드를 전송해드립니다.',
                          style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 13,
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
                        'ID',
                        style: TextStyle(
                            color: Color(0xff717171), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          hintText: '아이디',
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
                                    IdPage()));
                        },
                        child: Text(
                          '아이디를 잊으셨나요?',
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