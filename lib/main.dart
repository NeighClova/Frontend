import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neighclova/auth/check_password_page.dart';
import 'package:flutter_neighclova/auth/find_password_page.dart';
import 'package:flutter_neighclova/auth/join_page.dart';

import 'package:flutter_neighclova/place/register_info.dart';
import 'package:flutter_neighclova/tabview.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_links/app_links.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  runApp(const MyApp());
  MobileAds.instance.initialize(); //광고 초기화
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
  bool isFirst = true;
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
    userInfo = await storage.read(key: 'accessToken');

    if (userInfo != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TabView(),
          ),
          (route) => false);
    } else {
      print('로그인이 필요합니다');
    }
  }

  void naverLogin() async {
    final Uri loginUrl =
        Uri.parse('${dotenv.env['BASE_URL']!}/oauth2/authorization/naver');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WebViewContainer(loginUrl.toString(), redirectUri),
      ),
    );
  }

  getAllPlace() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.env['BASE_URL']!;

    try {
      Response response =
          await dio.post('/place/all');

      if (response.statusCode == 200) {
        List<dynamic> placeList = response.data['placeList']; 
        if (placeList.isEmpty)
          isFirst = true;
        else
          isFirst = false;
        return;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  routeway() async {
    // 데이터 없으면 null
    email = await storage.read(key: 'email');
    //업체 첫 등록 확인
    getAllPlace();

    if (!isFirst) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TabView(),
          ),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => RegisterInfo(),
          ),
          (route) => false);
    }
  }

  Future<bool> loginAction(id, password) async {
    try {
      var dio = Dio();
      var param = {'uid': id, 'password': password};
      dio.options.baseUrl = dotenv.env['BASE_URL']!;

      Response response = await dio.post('/auth/sign-in', data: param);

      if (response.statusCode == 200) {
        email = response.data['email'];
        await storage.write(
          key: 'accessToken',
          value: response.data['accessToken'],
        );
        await storage.write(
          key: 'refreshToken',
          value: response.data['refreshToken'],
        );
        await storage.write(
          key: 'password',
          value: password,
        );
        await storage.write(
          key: 'email',
          value: email,
        );
        await storage.write(
          key: 'id',
          value: id,
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
                                hintText: '아이디 입력',
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
                                      context, Text('아이디나 비밀번호가 옳지 않습니다.'));
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

  Map<String, dynamic> parseJwtPayLoad(String accessToken) {
    final parts = accessToken.split('.');
    if (parts.length != 3) {
      throw Exception('invalid accessToken');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String? getUserIdFromToken(String accessToken) {
    final payload = parseJwtPayLoad(accessToken);
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
            String? accessToken = Uri.parse(request.url).pathSegments.length > 3
                ? Uri.parse(request.url).pathSegments[2]
                : null;
            print('네이버 토큰: $accessToken');
            if (accessToken != null) {
              String? userId = getUserIdFromToken(accessToken);
              if (userId != null) {
                print('User ID: $userId');
                saveNaverToken(accessToken, userId);
              } else {
                print('User ID not found in accessToken');
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

  void saveNaverToken(String accessToken, String email) async {
    await storage.write(
      key: 'accessToken',
      value: accessToken,
    );
    await storage.write(
      key: 'email',
      value: email,
    );
    print('네이버 토큰 저장됨 : $accessToken');
    print('네이버 이메일 저장됨 : $email');

    dynamic isFirst = '';
    isFirst = await storage.read(key: email + 'First!');

    if (isFirst != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TabView(),
          ),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => RegisterInfo(),
          ),
          (route) => false);
    }
  }
}
