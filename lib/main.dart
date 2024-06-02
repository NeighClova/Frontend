import 'package:flutter/material.dart';
import 'package:flutter_neighclova/find_password_page.dart';
import 'package:flutter_neighclova/join_page.dart';
import 'package:flutter_neighclova/tabview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: Login(),
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
        ),
        primaryTextTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xff404040)),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xff404040)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Color(0xff404040)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Color(0xff404040)),
          ),
        ),
        fontFamily: 'Pretendard'
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controller = TextEditingController(); // 이메일
  TextEditingController controller2 = TextEditingController(); // 비밀번호
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 180)),
                  Center(
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                      width: 250.0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 82)),
                  Form(
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.grey,
                        inputDecorationTheme: InputDecorationTheme(
                          labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                isDense: true,
                                hintText: '이메일 입력',
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
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 15),
                            ),
                            Padding(padding: EdgeInsets.only(top: 16)),
                            TextField(
                              controller: controller2,
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible ? Icons.visibility : Icons.visibility_off,
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
                            SizedBox(height: 25.0),
                            ElevatedButton(
                              onPressed: () {
                                if (true /*아이디, 비밀번호 확인*/) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => TabView(),
                                    ),
                                  );
                                } else {
                                  showSnackBar(context, Text('이메일이나 비밀번호가 옳지 않습니다.'));
                                }
                              },
                              child: Text('로그인', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff03C75A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                minimumSize: Size.fromHeight(50),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 20)),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => PasswordPage(),
                                      ),
                                    );
                                  },
                                  child: Text('비밀번호 찾기', style: TextStyle(color: Color(0xff404040))),
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 30, 0)),
                                Container(
                                  width: 1.0,
                                  height: 15,
                                  color: Colors.grey,
                                  alignment: Alignment.center,
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => JoinPage(),
                                      ),
                                    );
                                  },
                                  child: Text('   회원가입    ', style: TextStyle(color: Color(0xff404040))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 25)),
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 1000.0),
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text('네이버로 간편하게 로그인하기', style: TextStyle(color: Color(0xff404040))),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 1000.0),
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 25)),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        print("네이버 로그인");
                      },
                      child: Image(
                        image: AssetImage('assets/naver_logo.png'),
                        width: 50.0,
                      ),
                    ),
                    SizedBox(height: 32.0),
                  ],
                ),
              ),
            ),
          ],
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