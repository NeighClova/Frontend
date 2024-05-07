import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/join_page.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:flutter_neighclova/main_page.dart';

class EmailAuthPage extends StatefulWidget {
  final Userdata userdata;
  const EmailAuthPage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState(userdata:userdata);
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
              Padding(padding: EdgeInsets.only(top: 110)),
              Center(
                  child: Text('코드를 보내드렸습니다',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:Colors.black,
                      fontSize: 25,
                    )
                  ),
                ),
              Padding(padding: EdgeInsets.only(top: 25)),
              Center(
                child: Text(userdata.email,
                  style: TextStyle(
                    color: Color(0xff03C75A),
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Center(
                child: Text('인증을 위해 아래에 코드를 입력해주세요.',
                  style: TextStyle(
                    color: Colors.black,
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
                                onChanged: (_) => FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff03C75A)),
                                  ),
                                  counterText: '',
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 35),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Flexible(
                              child: TextFormField(
                                controller: controller2,
                                maxLength: 1,
                                //textInputAction: TextInputAction.next,
                                onChanged: (_) => FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff03C75A)),
                                  ),
                                  counterText: '',
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 35),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Flexible(
                              child: TextFormField(
                                controller: controller3,
                                maxLength: 1,
                                //textInputAction: TextInputAction.next,
                                onChanged: (_) => FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff03C75A)),
                                  ),
                                  counterText: '',
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 35),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Flexible(
                              child: TextFormField(
                                controller: controller4,
                                maxLength: 1,
                                //textInputAction: TextInputAction.next,
                                onChanged: (_) => FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff03C75A)),
                                  ),
                                  counterText: '',
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 35),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Flexible(
                              child: TextFormField(
                                controller: controller5,
                                maxLength: 1,
                                //textInputAction: TextInputAction.next,
                                onChanged: (_) => FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff03C75A)),
                                  ),
                                  counterText: '',
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 35),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Flexible(
                              child: TextFormField(
                                controller: controller6,
                                maxLength: 1,
                                //textInputAction: TextInputAction.next,
                                onChanged: (_) => FocusScope.of(context).unfocus(),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff03C75A)),
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
                          onPressed: (){
                            /////////////////아이디, 비밀번호 DB 저장
                            /////////////////자동로그인
                            String code = controller.text + controller2.text + controller3.text + controller4.text + controller5.text + controller6.text;
                            print(code);
                            if (code == '123456'){
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                MainPage(),
                              )
                            );
                            }
                            else{
                              showSnackBar(context, Text('코드가 일치하지 않습니다.'));
                            }
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
                    ],
                  );
                })
                )
              ),
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