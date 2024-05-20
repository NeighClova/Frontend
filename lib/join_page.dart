import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/email_auth_page.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:flutter_neighclova/main_page.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  TextEditingController controller = TextEditingController();//이메일
  TextEditingController controller2 = TextEditingController();//비밀번호
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';
  
  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
          Padding(padding: EdgeInsets.only(top: 180)),
          Center(
            child: Image(
              image: AssetImage('assets/logo.png'),
              width: 250.0,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 50)),
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(40.0),
              child: Builder(builder: (context) {
                return Column(
                  children: [
                    TextFormField(
                      validator: (value){
                        if (value!.isEmpty || !value!.contains('@')){
                          return '유효한 이메일을 입력해주세요.';
                        }
                        else if (value! == 'ex@naver.com') {
                          return '이미 사용중인 이메일입니다.';
                        }
                        else{
                          return null;
                        }
                      },
                      onSaved: (value){
                        userEmail = value!;
                      },
                        controller: controller,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: '이메일',
                          hintText: 'example@company.com',
                          enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      TextFormField(
                        validator: (value){
                          String pwPattern = r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
                          RegExp regExp = RegExp(pwPattern);
                          String pwPattern2 = r'[a-zA-z]';
                          RegExp regExp2 = RegExp(pwPattern2);
                          String pwPattern3 = r'[0-9]';
                          RegExp regExp3 = RegExp(pwPattern3);

                          if (value!.length < 8 || value!.length > 15){
                            return '8자 이상 15자 이내로 입력하세요.';
                          }
                          else if (!regExp2.hasMatch(value!)){
                            return '영문을 포함해야 합니다.';
                          }
                          else if (!regExp3.hasMatch(value!)){
                            return '숫자를 포함해야 합니다.';
                          }
                          return null;
                      },
                      onSaved: (value){
                        userPassword = value!;
                      },
                        controller: controller2,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: '비밀번호',
                          hintText: '비밀번호 입력',
                          enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              passwordVisible = !passwordVisible;
                              print(passwordVisible);
                              setState(() {
                                
                              });
                            },
                          )
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 15),
                        obscureText: passwordVisible ? false : true,
                      ),
                      SizedBox(height: 30.0,),
                      ButtonTheme(
                        //minWidth: 1000.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () async{
                            _tryValidation();
                            if (_formKey.currentState!.validate()){
                              ///////////////////////////////이메일 인증 코드 보내기
                              final userdata = Userdata(userEmail, userPassword);
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  EmailAuthPage(userdata: userdata),
                                )
                              );
                            }
                          },
                          child: Text('회원가입', style: TextStyle(color:Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff03C75A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            minimumSize: Size.fromHeight(50),
                          ),
                        )
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('이미 계정이 있으신가요?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  Login())
                              );
                            },
                            child: Text('로그인',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xff404040),
                                fontSize: 12,
                              ),),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 100.0)),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                            constraints: BoxConstraints(maxWidth: 1000.0,),
                            height: 1,
                            width: 1000.0,
                            color:Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text('네이버로 간편하게 로그인하기', style: TextStyle(color: Color(0xff404040))),
                        SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                            constraints: BoxConstraints(maxWidth: 1000.0,),
                            height: 1,
                            width: 1000.0,
                            color:Colors.grey,
                            ),
                          )
                      ],
                      ),
                      SizedBox(height: 10.0),
                      InkWell(
                        onTap:() {
                          print("네이버 로그인");
                        },
                        child: Image(
                          image: AssetImage('assets/naver_logo.png'),
                          width: 50.0,
                        ),
                      ),
                  ],
                );
              },)
            ),
            )
            ]
          )
        )
      )
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

class Userdata{
  String email;
  String password;
  Userdata(this.email, this.password);
}