import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/auth/join_page.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:flutter_neighclova/main_page.dart';
import 'package:flutter_neighclova/place/register_info.dart';
import 'package:dio/dio.dart';

class EmailAuthPage extends StatefulWidget {
  final Userdata userdata;
  const EmailAuthPage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState(userdata: userdata);
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  final Userdata userdata;
  _EmailAuthPageState({required this.userdata});

  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  Future<bool> signInAction(code) async {
    try {
      var dio = Dio();
      var param = {
        'email': userdata.email,
        'password': userdata.password,
        'certificationNumber': code
      };
      print(userdata.email);
      print(userdata.password);
      dio.options.baseUrl = 'http://10.0.2.2:8080';

      Response response = await dio.post('/auth/sign-up', data: param);

      if (response.statusCode == 200) {
        print('이메일 인증 코드 일치');
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
          title: Image(
            image: AssetImage('assets/logo.png'),
            width: 130.0,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                child: Column(children: [
              Padding(padding: EdgeInsets.only(top: 110)),
              Center(
                child: Text('코드를 보내드렸습니다',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff404040),
                      fontSize: 25,
                    )),
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
              Center(
                child: Text(
                  userdata.email,
                  style: TextStyle(
                    color: Color(0xff03C75A),
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Center(
                child: Text(
                  '인증을 위해 아래에 코드를 입력해주세요.',
                  style: TextStyle(
                    color: Color(0xff404040),
                    fontSize: 17,
                  ),
                ),
              ),
              Form(
                  child: Container(
                      padding: EdgeInsets.all(40.0),
                      child: Builder(builder: (context) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      controller: controller,
                                      maxLength: 1,
                                      //textInputAction: TextInputAction.next,
                                      onChanged: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff03C75A)),
                                        ),
                                        counterText: '',
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: controller2,
                                      maxLength: 1,
                                      //textInputAction: TextInputAction.next,
                                      onChanged: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff03C75A)),
                                        ),
                                        counterText: '',
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: controller3,
                                      maxLength: 1,
                                      //textInputAction: TextInputAction.next,
                                      onChanged: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff03C75A)),
                                        ),
                                        counterText: '',
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: controller4,
                                      maxLength: 1,
                                      //textInputAction: TextInputAction.next,
                                      onChanged: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff03C75A)),
                                        ),
                                        counterText: '',
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: controller5,
                                      maxLength: 1,
                                      //textInputAction: TextInputAction.next,
                                      onChanged: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff03C75A)),
                                        ),
                                        counterText: '',
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: controller6,
                                      maxLength: 1,
                                      //textInputAction: TextInputAction.next,
                                      onChanged: (_) =>
                                          FocusScope.of(context).unfocus(),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff03C75A)),
                                        ),
                                        counterText: '',
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 120)),
                            ButtonTheme(
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    /////////////////아이디, 비밀번호 DB 저장
                                    /////////////////자동로그인
                                    String code = controller.text +
                                        controller2.text +
                                        controller3.text +
                                        controller4.text +
                                        controller5.text +
                                        controller6.text;
                                    print(code);
                                    Future<bool> result = signInAction(code);
                                    if (await result) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MyApp(),
                                          ),
                                          (route) => false);
                                    } else {
                                      showSnackBar(
                                          context, Text('코드가 일치하지 않습니다.'));
                                    }
                                  },
                                  child: Text('확인',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff03C75A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    minimumSize: Size.fromHeight(50),
                                  ),
                                )),
                          ],
                        );
                      }))),
            ]))));
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: Color(0xff03C75A),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
