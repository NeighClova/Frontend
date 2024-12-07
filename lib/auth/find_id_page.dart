import 'package:flutter/material.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IdPage extends StatefulWidget {
  const IdPage({Key? key}) : super(key: key);

  @override
  State<IdPage> createState() => _IdPageState();
}

class _IdPageState extends State<IdPage> {
  TextEditingController controller = TextEditingController();

  void _handleButtonPressed() {
    /////////////////가입된 이메일인지 확인
    if (controller.text == 'sojin49@naver.com') {
      final email = 'sojin49@naver.com';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              SendMailPage(email: email),
        ));
    } else {
      showSnackBar(context, Text('가입되지 않은 이메일입니다.'));
    }
  }

  Future<bool> findId(email) async {
    try {
      var dio = Dio();
      var param = {
        'email': email,
      };
      dio.options.baseUrl = dotenv.env['BASE_URL']!;

      Response response = await dio.post('/auth/send-uid', data: param);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        print('존재하지 않는 아이디');
        showSnackBar(context, Text('존재하지 않는 아이디입니다.'));
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
            title: Text('아이디 찾기',
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
                        '이메일',
                        style: TextStyle(
                            color: Color(0xff717171), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          hintText: 'example@company.com',
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
                    ]);
                  }))),
                ),
              ),
            ]))),
            bottomNavigationBar: SafeArea(
                child: Container(
                  height: 70,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        Future<bool> result = findId(controller.text);
                        if (await result) {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SendMailPage(email: controller.text),
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

//메일 발송 페이지
class SendMailPage extends StatelessWidget {
  final String email;
  const SendMailPage({Key? key, required this.email}) : super(key: key);

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
        body: Column(children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Align(
              //crossAxisAlignment: CrossAxisAlignment.start,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text('아이디 찾기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff404040),
                      fontSize: 20,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              Padding(padding: EdgeInsets.only(top: 10)),
              Text('회원님의 아이디가 메일로 발송되었습니다.',
                  style: TextStyle(
                    color: Color(0xff404040),
                    fontSize: 16,
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
