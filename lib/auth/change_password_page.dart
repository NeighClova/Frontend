import 'package:flutter/material.dart';
import 'package:flutter_neighclova/auth/password_email_auth_page.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neighclova/auth_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;
  const ChangePasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState(email: email);
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final String email;
  _ChangePasswordPageState({required this.email});

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();
  String userPassword = '';
  String checkPassword = '';
  bool passwordVisible = false;
  bool passwordVisible2 = false;
  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  Future<bool> patchPassword(password) async {
    try {
      var dio = Dio();
      var param = {
        'email': email,
        'newPassword': password
      };
      dio.options.baseUrl = dotenv.env['BASE_URL']!;

      Response response = await dio.patch('/auth/no-auth/patch-password', data: param);

      if (response.statusCode == 200) {
        print('비밀번호 변경 성공');
        return true;
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
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 25)),
                        Text(
                          '• 다른 사이트에서 사용하는 것과 동일하거나 쉬운 비밀번호는 사용하지 마세요.',
                          style: TextStyle(
                            color: Color(0xff404040),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '• 안전한 계정 사용을 위해 비밀번호는 주기적으로 변경해주세요.',
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
                child: Center(
                  child:
                    Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Builder(
                        builder: (context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '새 비밀번호',
                                style: TextStyle(
                                    color: Color(0xff717171), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              TextFormField(
                                validator: (value) {
                                  String pwPattern =
                                      r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
                                  RegExp regExp = RegExp(pwPattern);
                                  String pwPattern2 = r'[a-zA-Z]';
                                  RegExp regExp2 = RegExp(pwPattern2);
                                  String pwPattern3 = r'[0-9]';
                                  RegExp regExp3 = RegExp(pwPattern3);

                                  if (value!.length < 8 || value!.length > 15) {
                                    return '8자 이상 15자 이내로 입력하세요.';
                                  } else if (!regExp2.hasMatch(value)) {
                                    return '영문을 포함해야 합니다.';
                                  } else if (!regExp3.hasMatch(value)) {
                                    return '숫자를 포함해야 합니다.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userPassword = value!;
                                },
                                controller: newPasswordController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
                                  hintText: '비밀번호 입력',
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
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      passwordVisible = !passwordVisible;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 15),
                                obscureText: !passwordVisible,
                              ),
                              Padding(padding: EdgeInsets.only(top: 22)),
                              Text(
                                '새 비밀번호 재입력',
                                style: TextStyle(
                                    color: Color(0xff717171), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty || value != newPasswordController.text) {
                                    return '비밀번호가 같지 않습니다.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  checkPassword = value!;
                                },
                                controller: checkPasswordController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
                                  hintText: '비밀번호 입력',
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
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      passwordVisible2 = !passwordVisible2;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 15),
                                obscureText: !passwordVisible2,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
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
                        _tryValidation();
                        if (_formKey.currentState!.validate()) {
                          //바뀐 비밀번호 저장
                          Future<bool> result = patchPassword(userPassword);
                          if (await result) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Login(),
                              ),
                              (route) => false);
                          }
                          else {
                            showSnackBar(context, Text('비밀번호를 다시 확인해주세요.'));
                          }
                        };
                      },
                      child: Text(
                        '비밀번호 변경',
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

//메일 발송 페이지
class SendMailPage extends StatelessWidget {
  final String email;
  const SendMailPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shape: Border(
              bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          )),
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
        body: Column(children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Align(
              //crossAxisAlignment: CrossAxisAlignment.start,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text('비밀번호 찾기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff404040),
                      fontSize: 25,
                    )),
              )),
          Center(
              child: Column(
            children: [
              Image(
                image: AssetImage('assets/email.png'),
                width: 250.0,
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
              Text(email,
                  style: TextStyle(
                    color: Color(0xff03C75A),
                    fontSize: 15,
                  )),
              Padding(padding: EdgeInsets.only(top: 10)),
              Text('코드를 보내드렸습니다.',
                  style: TextStyle(
                    color: Color(0xff404040),
                    fontSize: 17,
                  )),
              Padding(padding: EdgeInsets.only(top: 25)),
              Container(
                padding: EdgeInsets.all(40.0),
                child: ButtonTheme(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Login(),
                            ),
                            (route) => false);
                      },
                      child: Text('확인', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff03C75A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size.fromHeight(50),
                      ),
                    )),
              ),
            ],
          )),
        ]));
  }
}
