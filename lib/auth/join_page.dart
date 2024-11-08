import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neighclova/auth/email_auth_page.dart';
import 'package:flutter_neighclova/main.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter_neighclova/place/register_info.dart';
import 'package:flutter_neighclova/tabview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  TextEditingController email = TextEditingController(); // 이메일
  TextEditingController password = TextEditingController(); // 비밀번호
  TextEditingController id = TextEditingController();
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';
  String userId = '';

  //네이버 로그인
  late AppLinks _appLinks;
  final String redirectUri = 'http://localhost:3000/auth/oauth-response';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  emailCheckAction(email) async {
    try {
      var dio = Dio();
      var param = {'email': email};
      dio.options.baseUrl = dotenv.env['BASE_URL']!;

      Response response = await dio.post('/auth/email-check', data: param);

      if (response.statusCode == 200) {
        print('중복되지 않음');
        return true;
      } else if (response.statusCode == 400) {
        print('중복된 이메일 존재');
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

  emailCertificationAction(email) async {
    try {
      var dio = Dio();
      var param = {'email': email};
      dio.options.baseUrl = dotenv.env['BASE_URL']!;

      Response response =
          await dio.post('/auth/email-certification', data: param);

      if (response.statusCode == 200) {
        print('이메일 전송');
        return true;
      } else if (response.statusCode == 400) {
        print('중복된 이메일 존재');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 전체 레이아웃이 변경되지 않도록 설정
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 130)),
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
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Builder(
                        builder: (context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID',
                                style: TextStyle(
                                    color: Color(0xff717171), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty || value.length < 5 || value.length > 15) {
                                    return '영문 5~15자로 입력해주세요.';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  userId = value!;
                                },
                                controller: id,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
                                  hintText: '아이디',
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
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(fontSize: 15),
                              ),
                              Padding(padding: EdgeInsets.only(top: 22)),
                              Text(
                                '비밀번호',
                                style: TextStyle(
                                    color: Color(0xff717171), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
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
                                '이메일',
                                style: TextStyle(
                                    color: Color(0xff717171), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return '유효한 이메일을 입력해주세요.';
                                  } else if (emailCheckAction(email.text) ==
                                      false) {
                                    return '이미 사용중인 이메일입니다.';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  userEmail = value!;
                                },
                                controller: email,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
                                  hintText: 'example@company.com',
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
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 60.0),
                              ElevatedButton(
                                onPressed: () async {
                                  _tryValidation();
                                  if (_formKey.currentState!.validate()) {
                                    // 이메일 인증 코드 보내기
                                    emailCertificationAction(email.text);
                                    final userdata =
                                        Userdata(userEmail, userPassword, userId);
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EmailAuthPage(userdata: userdata),
                                      ),
                                    );
                                  }
                                },
                                child: Text('회원가입',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff03C75A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  minimumSize: Size.fromHeight(50),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '이미 계정이 있으신가요?',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Login(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '로그인',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff404040),
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //SizedBox(height: 150.0),
                            ],
                          );
                        },
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

  ScaffoldMessenger.of(context).showSnackBar;
}

class Userdata {
  String email;
  String password;
  String id;
  Userdata(this.email, this.password, this.id);
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
    isFirst = await storage.read(key: email + 'First');

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
