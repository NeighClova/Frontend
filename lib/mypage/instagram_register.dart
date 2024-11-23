import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InstagramRegister extends StatefulWidget {
  const InstagramRegister({Key? key}) : super(key: key);

  @override
  State<InstagramRegister> createState() => _InstagramRegisterState();
}

class _InstagramRegisterState extends State<InstagramRegister> {
  dynamic IGName = '';
  dynamic IGPassword = '';
  TextEditingController IGNameController = TextEditingController();
  TextEditingController IGPasswordController = TextEditingController();
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  static final storage = FlutterSecureStorage();
  dynamic placeId;
  Map<String, String> _allValues = {};

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    await _getAllValues();
    await getPlaceId();
    print('getName 실행');
    await getIGName();
    print('getPassword 실행');
    await getIGPassword();

    setState(() {
      IGNameController = TextEditingController(text: IGName);
      IGPasswordController = TextEditingController(text: IGPassword);
    });
  }

  Future<void> _getAllValues() async {
    final allValues = await storage.readAll();
    print("Secure Storage 모든 값: $allValues");
    setState(() {
      _allValues = allValues;
    });
  }

  Future<void> getPlaceId() async {
    String? storedPlaceId = await storage.read(key: 'placeId');
    setState(() {
      placeId = storedPlaceId;
    });
    print('placeID : $placeId');
  }

  Future<void> getIGName() async {
    print('IG 이름 얻기');
    String? storedIGName = await storage.read(key: placeId + 'IGName');
    setState(() {
      IGName = storedIGName;
    });
    print('IGName : $IGName');
  }

  Future<void> getIGPassword() async {
    print('IG비번 얻기');
    String? storedIGName = await storage.read(key: placeId + 'IGPassword');
    setState(() {
      IGPassword = storedIGName;
    });
    print('IGPassword : $IGPassword');
  }

  Future<void> _handleRegisterIG() async {
    //백엔드
    // if (_formKey.currentState!.validate()) {
    //   //Future<bool> result = patchPasswordAction(userPassword, newPassword);
    //   if (await result) {
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(
    //           builder: (BuildContext context) => MyApp(),
    //         ),
    //         (route) => false);
    //   }
    // }
    //등록 여부 저장, 백엔드 코드 안에 넣기
    placeId = await storage.read(key: 'placeId');
    await storage.write(
      key: placeId + 'IGName',
      value: IGNameController.text,
    );
    await storage.write(
      key: placeId + 'IGPassword',
      value: IGPasswordController.text,
    );
    Navigator.pop(context, true);
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
        title: Text('인스타그램 계정 연결',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff404040),
              fontSize: 20,
            )),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: ElevatedButton(
              onPressed: () async {
                _handleRegisterIG();
              },
              child: Text(
                '저장',
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
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Center(
                    child: Image.asset(
                      'assets/IG.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Form(
                      key: _formKey,
                      child: Container(child: Builder(builder: (context) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '사용자 이름',
                                style: TextStyle(
                                    color: Color(0xff717171),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '유효한 사용자 이름을 입력해주세요.';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  IGName = value!;
                                },
                                controller: IGNameController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
                                  hintText: '사용자 이름 입력',
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
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Text(
                                '비밀번호',
                                style: TextStyle(
                                  color: Color(0xff717171),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '유효한 비밀번호를 입력해주세요.';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  IGPassword = value!;
                                },
                                controller: IGPasswordController,
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
                            ]);
                      }))),
                  Padding(padding: EdgeInsets.only(top: 30)),
                ],
              ),
            ),
          )),
    );
  }
}
