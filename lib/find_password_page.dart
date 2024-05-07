import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/join_page.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:flutter_neighclova/main_page.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  TextEditingController controller = TextEditingController();

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
        title: Image(
          image: AssetImage('assets/logo.png'),
          width: 130.0,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 50)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('비밀번호 찾기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:Colors.black,
                          fontSize: 25,
                        )
                      ),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      Text('회원가입 시 기입했던 이메일을 입력해주세요.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      Text('비밀번호 재설정 메일을 보내드립니다.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ]
                  ),
                ),
              ),
              
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Form(
                    child: Container(
                    child: Builder(builder: (context) {
                      return Column(
                        children: [
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
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
                        ]
                      );
                    })
                  )
                ),
              ),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              Center(
                child: Container(
                  padding: EdgeInsets.all(40.0),
                  child: ButtonTheme(
                  height: 50.0,
                  child: ElevatedButton(
                  onPressed: () async{
                    /////////////////가입된 이메일인지 확인
                    if (controller.text == 'ex@naver.com'){
                      final email = controller.text;
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                          SendMailPage(email: email),
                        )
                      );
                    }
                    else{
                      showSnackBar(context, Text('가입되지 않은 이메일입니다.'));
                    }
                  },
                  child: Text('비밀번호 재설정하기', style: TextStyle(color:Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff03C75A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: Size.fromHeight(50),
                  ),
                  )
                ),
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
          )
        ),
        title: Image(
          image: AssetImage('assets/logo.png'),
          width: 130.0,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Align(
            //crossAxisAlignment: CrossAxisAlignment.start,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 40),
              child: Text('비밀번호 찾기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Colors.black,
                  fontSize: 25,
                )
              ),
            )
          ),
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
                    color:Color(0xff03C75A),
                    fontSize: 15,
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text('비밀번호 재설정 메일이 발송되었습니다.',
                  style: TextStyle(
                    color:Colors.black,
                    fontSize: 17,
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 25)),
                Container(
                  padding: EdgeInsets.all(40.0),
                  child: ButtonTheme(
                  height: 50.0,
                  child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                        Login(),
                      ), (route) => false
                    );
                  },
                    child: Text('확인', style: TextStyle(color:Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff03C75A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      minimumSize: Size.fromHeight(50),
                    ),
                    )
                  ),
                ),
              ],
            )
          ),
        ]
      )
    );
  }
}