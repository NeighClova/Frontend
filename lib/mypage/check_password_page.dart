import 'package:flutter/material.dart';
import 'package:flutter_neighclova/auth/no_auth_change_password_page.dart';
import 'package:flutter_neighclova/auth/find_id_page.dart';
import 'package:flutter_neighclova/auth/find_password_page.dart';
import 'package:flutter_neighclova/auth/password_email_auth_page.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:flutter_neighclova/mypage/change_password_page%20copy.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CheckPasswordPage extends StatefulWidget {
  const CheckPasswordPage({Key? key}) : super(key: key);

  @override
  State<CheckPasswordPage> createState() => _CheckPasswordPageState();
}

class _CheckPasswordPageState extends State<CheckPasswordPage> {
  TextEditingController controller = TextEditingController();
  bool passwordVisible = false;

  void _handleButtonPressed() {
    if (controller.text == 'password') {
      final id = 'testid';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ChangePasswordPage(),
        ));
    } else {
      showSnackBar(context, Text('비밀번호가 옳지 않습니다.'));
    }
  }

  Future<bool> checkPassword(password) async {
    try {
      var dio = Dio();
      var param = {
        'password': password
      };
      dio.options.baseUrl = dotenv.env['BASE_URL']!;

      Response response = await dio.post('/auth/check-password', data: param);

      if (response.statusCode == 200) {
        print('비밀번호 확인 성공');
        return true;
      } else if (response.statusCode == 403) {
        print('비밀번호 일치하지 않음');
        showSnackBar(context, Text('비밀번호가 일치하지 않습니다.'));
        return false;
      } else {
        print('error: ${response.statusCode}');
        showSnackBar(context, Text('오류가 발생했습니다.'));
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
            title: Text('비밀번호 변경',
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 15),
                        obscureText: !passwordVisible,
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
                      onPressed: () async {
                        Future<bool> result = checkPassword(controller.text);
                        if (await result) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChangePasswordPage(),
                            ));
                        }
                      },
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