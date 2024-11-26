import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neighclova/mypage/instagram_register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter_neighclova/auth_dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class NewsCard extends StatefulWidget {
  final int number;
  final String title;
  final String content;
  final String placeName;
  final String createdAt;
  final String profileImg;

  NewsCard({
    required this.number,
    required this.title,
    required this.content,
    required this.placeName,
    required this.createdAt,
    required this.profileImg,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final GlobalKey _titleKey = GlobalKey();
  double _titleHeight = 0;

  final GlobalKey _contentKey = GlobalKey();
  double _contentHeight = 0;

  static final storage = FlutterSecureStorage();
  dynamic IGName;
  dynamic IGPassword;
  dynamic placeId;

  final picker = ImagePicker();
  dynamic sendData;
  XFile? _pickedFile;
  MultipartFile? img;

  Future<bool> getInstagram() async {
    placeId = await storage.read(key: 'placeId');
    try {
      var dio = await authDio(context);
      var param = {
        'placeId': placeId,
      };

      Response response = await dio.get('/place/instagram', queryParameters: param);

      if (response.statusCode == 200) {
        print('인스타그램 계정 조회 성공');
        var data = response.data;
        String instagramId = data['instagramId'];
        String instagramPw = data['instagramPw'];

        IGName = instagramId;
        IGPassword = instagramPw;

        return true;
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

  Future<bool> uploadInstagram(String currentText) async {
    placeId = await storage.read(key: 'placeId');
    try {
      var dio = await authDio(context);

      String sanitizedContent = currentText.replaceAll('\n', ' ').trim();
      String dtoJson = '{"placeId": "$placeId", "content": "$sanitizedContent"}';
      print('placeId : $placeId');
      print('content : $sanitizedContent');
      FormData formData = FormData.fromMap({
        'dto': MultipartFile.fromString(dtoJson, contentType: MediaType('application', 'json')),
        'file': img
      });

      Response response = await dio.post('/place/instagram/upload', data: formData);

      if (response.statusCode == 200) {
        print('인스타그램 업로드 성공');

        return true;
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

  void _updateTitleHeight() {
    final RenderBox? renderBox =
        _titleKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _titleHeight = renderBox.size.height;
      });
    }
    print('title 크기 : ${_titleHeight}');
  }

  void _updateContentHeight() {
    final RenderBox? renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _contentHeight = renderBox.size.height;
      });
    }
    print('content 크기 : ${_contentHeight}');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleHeight();
      _updateContentHeight();
    });
    //_initialize();
  }

  // Future<void> _initialize() async {

  // }


  @override
Widget build(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(left: 10)),
        Container(
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              ClipOval(
                child: Container(
                  width: 40,
                  height: 40,
                  color: Color.fromRGBO(161, 182, 233, 1),
                  child: widget.profileImg != ''
                      ? Image.network(
                          '${widget.profileImg}',
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.placeName,
                        style: TextStyle(
                          color: Color(0xff404040),
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.createdAt,
                        style: TextStyle(
                          color: Color(0xff404040),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Future<bool> result = getInstagram();
                  if (await result) {
                    if (IGName == null && IGPassword == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              InstagramRegister(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            title: Text(
                              '인스타그램 업로드',
                              textAlign: TextAlign.center,
                            ),
                            contentPadding: EdgeInsets.zero,
                            actionsPadding: EdgeInsets.zero,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  '인스타그램에 게시물을 업로드 하시겠어요?',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            actions: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Divider(height: 1, color: Colors.grey),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Color(0xff404040),
                                            ),
                                            child: Text(
                                              '취소',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 48,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () async {
                                              String currentText =
                                                  widget.content;
                                              await _showBottomSheet();
                                              Future<bool> success =
                                                  uploadInstagram(
                                                      currentText);
                                              if (await success) {
                                                Navigator.pop(context, true);
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Color(0xff03AA5A),
                                            ),
                                            child: Text(
                                              '업로드',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Image(
                  image: AssetImage('assets/IG.png'),
                  width: 25.0,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 5)),
              SizedBox(
                width: 80,
                child: OutlinedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.content));
                    showToast();
                  },
                  child: const Text(
                    '복사하기',
                    style: TextStyle(
                      color: Color(0xff03AA5A),
                      fontSize: 12,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(5),
                    side: BorderSide(color: Color(0xff03AA5A), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: Size(70, 20),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 20)),
            ],
          ),
        ),

        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key: _titleKey,
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    key: _contentKey,
                    widget.content,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  _showBottomSheet(){
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await _getCameraImage();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff404040)),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.center,
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                child: const Text('사진찍기'),
              ),
            ),
            const Divider(
              thickness: 3,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await _getPhotoLibraryImage();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Color(0xff404040)),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.center,
                  textStyle: MaterialStateProperty.all(
                    TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                child: const Text('앨범에서 불러오기'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print('이미지 경로: ${pickedFile.path}');
      sendData = pickedFile.path;
      img = await MultipartFile.fromFile(sendData);
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      sendData = pickedFile.path;
      img = await MultipartFile.fromFile(sendData);
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }
}

void showToast() {
  Fluttertoast.showToast(
    msg: '클립보드에 복사되었습니다.',
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Color(0xff404040),
    fontSize: 15,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}
