import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/auth/find_password_page.dart';
import 'package:flutter_neighclova/mypage/mypage.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  bool passwordVisible = false;
  bool passwordVisible2 = false;
  bool passwordVisible3 = false;
  final _formKey = GlobalKey<FormState>();
  String userPassword = '';
  String newPassword = '';
  String checkNewPassword = '';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  void initState() {
    passwordVisible = false;
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
      bottomNavigationBar: Container(
        height: 60,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: ElevatedButton(
            onPressed: () async {
              //////////데이터 전달
              _tryValidation();
              if (_formKey.currentState!.validate()) {
                print('비밀번호 변경 완료');
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyPage(),
                    ));
              }
            },
            child: Text(
              '비밀번호 변경',
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
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• 다른 사이트에서 사용하는 것과 동일하거나 쉬운 비밀번호는 사용하지 마세요.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '• 안전한 계정 사용을 위해 비밀번호는 주기적으로 변경해주세요.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Form(
                      key: _formKey,
                      child: Container(
                          //padding: EdgeInsets.all(40.0),
                          child: Builder(builder: (context) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '현재 비밀번호',
                                style: TextStyle(
                                  color: Color(0xff717171),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              TextFormField(
                                validator: (value) {
                                  if (value! != 'qwerty123') {
                                    return '비밀번호가 일치하지 않습니다.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userPassword = value!;
                                },
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
                                        passwordVisible = !passwordVisible;
                                        print(passwordVisible);
                                        setState(() {});
                                      },
                                    )),
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 15),
                                obscureText: passwordVisible ? false : true,
                              ),
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Text(
                                '새 비밀번호',
                                style: TextStyle(
                                  color: Color(0xff717171),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              TextFormField(
                                validator: (value) {
                                  String pwPattern =
                                      r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
                                  RegExp regExp = RegExp(pwPattern);
                                  String pwPattern2 = r'[a-zA-z]';
                                  RegExp regExp2 = RegExp(pwPattern2);
                                  String pwPattern3 = r'[0-9]';
                                  RegExp regExp3 = RegExp(pwPattern3);

                                  if (value!.length < 8 || value!.length > 15) {
                                    return '8자 이상 15자 이내로 입력하세요.';
                                  } else if (!regExp2.hasMatch(value!)) {
                                    return '영문을 포함해야 합니다.';
                                  } else if (!regExp3.hasMatch(value!)) {
                                    return '숫자를 포함해야 합니다.';
                                  } else if (value! == controller.text) {
                                    return '현재 비밀번호는 사용할 수 없습니다.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  newPassword = value!;
                                },
                                controller: controller2,
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
                                        passwordVisible2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        passwordVisible2 = !passwordVisible2;
                                        print(passwordVisible2);
                                        setState(() {});
                                      },
                                    )),
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 15),
                                obscureText: passwordVisible2 ? false : true,
                              ),
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Text(
                                '새 비밀번호 재입력',
                                style: TextStyle(
                                  color: Color(0xff717171),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              TextFormField(
                                validator: (value) {
                                  if (value! != controller2.text) {
                                    return '비밀번호가 같지 않습니다.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userPassword = value!;
                                },
                                controller: controller3,
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
                                        passwordVisible3
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        passwordVisible3 = !passwordVisible3;
                                        print(passwordVisible3);
                                        setState(() {});
                                      },
                                    )),
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 15),
                                obscureText: passwordVisible3 ? false : true,
                              ),
                            ]);
                      }))),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PasswordPage()));
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Color(0xff404040)),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      alignment: Alignment.center,
                      padding:
                          MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    child: Text(
                      '비밀번호를 잊으셨나요?',
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
