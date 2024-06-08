import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neighclova/auth/find_password_page.dart';
import 'package:flutter_neighclova/auth/join_page.dart';
import 'package:flutter_neighclova/main_page.dart';
import 'package:flutter_neighclova/place/register_info.dart';
import 'package:flutter_neighclova/tabview.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_neighclova/auth/model.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
              foregroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff404040)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff404040)),
            ),
          ),
          fontFamily: 'Pretendard'),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool passwordVisible = false;

  static final storage = FlutterSecureStorage();
  dynamic isFirst = ''; //storage 내의 유저 정보 저장
  dynamic email = '';
  dynamic userInfo = '';

  //네이버 로그인
  late AppLinks _appLinks;
  final String redirectUri = 'http://localhost:3000/auth/oauth-response';

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
    _appLinks = AppLinks();
    //_initDeepLinks();
    if (WebView.platform == null) {
      WebView.platform = SurfaceAndroidWebView();
    }
    //flutter secure storage 정보 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key:'token');

    if (userInfo != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              TabView(),
        ),
        (route) => false);
    } else {
      print('로그인이 필요합니다');
    }
  }

  void naverLogin() async {
    final Uri loginUrl = Uri.parse('http://192.168.35.197:8080/oauth2/authorization/naver');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewContainer(loginUrl.toString(), redirectUri),
      ),
    );
  }

  routeway() async {
    
    // 데이터 없으면 null
    email = await storage.read(key: 'email');
    isFirst = await storage.read(key: email + 'First');

    if (isFirst != null) {
      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => TabView(),
        ),
      );*/
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              TabView(),
        ),
        (route) => false);

      /*await storage.write(
        key: 'isFirst',
        value: 'false',
      );*/
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              RegisterInfo(),
        ),
        (route) => false);
    }
  }

  Future<bool> loginAction(email, password) async {
    
    try {
      var dio = Dio();
      var param = {'email': email, 'password': password};
      dio.options.baseUrl = 'http://192.168.35.197:8080';

      Response response = await dio.post('/auth/sign-in', data: param);

      print("***************************");
      print(response.data['token']);
      if (response.statusCode == 200) {
        await storage.write(
          key: 'token',
          value: response.data['token'],
        );
        await storage.write(
          key: 'password',
          value: password,
        );
        await storage.write(
          key: 'email',
          value: email,
        );
        print('로그인 정보 일치');
        return true;
      } else if (response.statusCode == 401) {
        print('로그인 정보 불일치');
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
                          labelStyle:
                              TextStyle(color: Colors.teal, fontSize: 15.0),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            TextField(
                              controller: username,
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
                              controller: password,
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
                            SizedBox(height: 25.0),
                            ElevatedButton(
                              onPressed: () async {
                                Future<bool> result =
                                    loginAction(username.text, password.text);
                                if (await result) {
                                  routeway();
                                } else {
                                  showSnackBar(
                                      context, Text('이메일이나 비밀번호가 옳지 않습니다.'));
                                }
                              },
                              child: Text('로그인',
                                  style: TextStyle(color: Colors.white)),
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
                                        builder: (BuildContext context) =>
                                            PasswordPage(),
                                      ),
                                    );
                                  },
                                  child: Text('비밀번호 찾기',
                                      style:
                                          TextStyle(color: Color(0xff404040))),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0)),
                                Container(
                                  width: 1.0,
                                  height: 15,
                                  color: Colors.grey,
                                  alignment: Alignment.center,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            JoinPage(),
                                      ),
                                    );
                                  },
                                  child: Text('   회원가입    ',
                                      style:
                                          TextStyle(color: Color(0xff404040))),
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
                padding: const EdgeInsets.only(bottom: 0.0),
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
                        Text('네이버로 간편하게 로그인하기',
                            style: TextStyle(color: Color(0xff404040))),
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
                        //naverLogin();
                        naverLogin();
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

class WebViewContainer extends StatefulWidget {
  final String url;
  final String redirectUri;
  WebViewContainer(this.url, this.redirectUri);

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late WebViewController _controller;

  static final storage = FlutterSecureStorage();

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Map<String, dynamic> parseJwtPayLoad(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String? getUserIdFromToken(String token) {
    final payload = parseJwtPayLoad(token);
    return payload['sub'] ?? payload['user_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith(widget.redirectUri)) {
            String? token = Uri.parse(request.url).pathSegments.length > 3
                ? Uri.parse(request.url).pathSegments[2]
                : null;
            print('네이버 토큰: $token');
            if (token != null) {
              String? userId = getUserIdFromToken(token);
              if (userId != null) {
                print('User ID: $userId');
                saveNaverToken(token, userId);
              } else {
                print('User ID not found in token');
              }
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
      ),
    );
  }

  void saveNaverToken(String token, String email) async {
    await storage.write(
      key: 'token',
      value: token,
    );
    await storage.write(
      key: 'email',
      value: email,
    );
    print('네이버 토큰 저장됨 : $token');
    print('네이버 이메일 저장됨 : $email');

    dynamic isFirst = '';
    isFirst = await storage.read(key: email + 'First!');

    if (isFirst != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              TabView(),
        ),
        (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              RegisterInfo(),
        ),
        (route) => false);
    }
  }
}