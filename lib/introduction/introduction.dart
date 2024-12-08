import 'package:flutter/material.dart';
import 'package:flutter_neighclova/admob.dart';
import 'package:flutter_neighclova/introduction/generate_introduction.dart';
import 'package:flutter_neighclova/introduction/introduction_response.dart';
import 'package:flutter_neighclova/mypage/instagram_register.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_neighclova/auth_dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  void initState() {
    super.initState();
    getIntroduceAction();
    //createInterstitialAd();
  }

  String? placeProfileImg = "";
  String? placeName = "";
  String? placeCategory = "";
  bool isProfileImgExist = false;
  final pageController = PageController();
  List<Introduces>? introduceList = [];

  static final storage = FlutterSecureStorage();
  dynamic placeId;
  dynamic IGName;
  dynamic IGPassword;

  bool _isLoading = false;

  //InterstitialAd? _interstitialAd;

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

      String dtoJson = '{"placeId": "$placeId", "content": "$currentText"}';
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

  getIntroduceAction() async {
    var dio = await authDio(context);
    placeId = await storage.read(key: 'placeId');

    // 파라미터 설정
    Map<String, dynamic> queryParams = {
      'placeId': placeId,
    };

    try {
      Response response =
          await dio.get('/introduce', queryParameters: queryParams);

      if (response.statusCode == 200) {
        IntroducesResponse introducesResponse =
            IntroducesResponse.fromJson(response.data);

        setState(() {
          placeName = response.data['placeName'];
          placeCategory = response.data['placeCategory'];
          placeProfileImg = response.data['placeProfileImg'];

          if (placeProfileImg != null) {
            isProfileImgExist = true;
          }
          introduceList = introducesResponse.introduceList;
          _isLoading = false;
        });

        return;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _fetchIntroduction() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    getIntroduceAction();
  }

  /*void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: admob.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      // 전체 화면 모드 설정
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createInterstitialAd();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        },
      );
      _interstitialAd!.show();
      createInterstitialAd();
    }
  }*/

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
          title: const Text('소개 생성',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff404040),
                fontSize: 20,
              )),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 184,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: isProfileImgExist
                        ? NetworkImage('$placeProfileImg')
                            as ImageProvider<Object>
                        : AssetImage('assets/storeImg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 2,
                    spreadRadius: -2,
                    offset: const Offset(0, 2),
                  )
                ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        placeName ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        placeCategory ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffB3B3B3),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 501,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '가게 소개',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                            width: 50,
                            height: 50,
                            color: Color.fromRGBO(161, 182, 233, 1),
                            child: isProfileImgExist
                                ? Image.network('$placeProfileImg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity)
                                : const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  )),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 22)),
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 270,
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 45),
                              child: introduceList == null ||
                                      introduceList?.length == 0
                                  ? Center(
                                      child: Text(
                                        "아직 소개글을 생성하지 않으셨네요!\n인공지능을 통해 매장 소개글을\n쉽고 빠르게 작성해보세요.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff404040),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      controller: pageController,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: introduceList?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        var introduces = introduceList?[index];
                                        if (_isLoading == false) {
                                          return SingleChildScrollView(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 20, 20, 20),
                                            child: Text(
                                              introduces?.content ?? '',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xff404040),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                            ),
                          ),
                          Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: SmoothPageIndicator(
                                  controller: pageController,
                                  count: introduceList?.length ?? 0,
                                  effect: const ScrollingDotsEffect(
                                    activeDotColor: Color(0xff03AA5A),
                                    activeStrokeWidth: 10,
                                    activeDotScale: 1.7,
                                    maxVisibleDots: 5,
                                    radius: 8,
                                    spacing: 10,
                                    dotHeight: 5,
                                    dotWidth: 5,
                                  ),
                                ),
                              )),
                          Positioned(
                              bottom: 12,
                              right: 40,
                              child: Visibility(
                                visible: introduceList != null &&
                                    introduceList?.length != 0,
                                child: InkWell(
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                backgroundColor: Colors.white,
                                                elevation: 0,
                                                title: Text(
                                                  '인스타그램 업로드',
                                                  textAlign: TextAlign.center,
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                                actionsPadding: EdgeInsets.zero,
                                                content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Text(
                                                        '인스타그램에 게시물을 업로드 하시겠어요?',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(height: 20),
                                                    ]),
                                                actions: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        child: Divider(
                                                            height: 1,
                                                            color: Colors.grey),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Center(
                                                            child: TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Color(
                                                                          0xff404040),
                                                                ),
                                                                child: Text(
                                                                  '취소',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )),
                                                          )),
                                                          Container(
                                                            height: 48,
                                                            width: 1,
                                                            color: Colors.grey,
                                                          ),
                                                          Expanded(
                                                              child: Center(
                                                            child: TextButton(
                                                                onPressed:
                                                                    () async {
                                                                      int currentPage =
                                                                        pageController.page?.round() ?? 0;
                                                                    var introduces = introduceList?[currentPage];
                                                                    String currentText =
                                                                        introduces?.content ?? ' ';
                                                                    await _showBottomSheet();
                                                                    Future<bool> success = uploadInstagram(currentText);
                                                                    if (await success) {
                                                                      Navigator.pop(context, true);
                                                                    }
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      Color(
                                                                          0xff03AA5A),
                                                                ),
                                                                child: Text(
                                                                  '업로드',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )),
                                                          ))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      }
                                    }
                                  },
                                  child: Image(
                                    image: AssetImage('assets/IG.png'),
                                    width: 25.0,
                                  ),
                                ),
                              )),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Visibility(
                              visible: introduceList != null &&
                                  introduceList?.length != 0,
                              child: IconButton(
                                onPressed: () {
                                  int currentPage =
                                      pageController.page?.round() ?? 0;
                                  var introduces = introduceList?[currentPage];
                                  String currentText =
                                      introduces?.content ?? ' ';
                                  Clipboard.setData(
                                      ClipboardData(text: currentText));
                                  showToast();
                                },
                                icon: Icon(Icons.content_copy_outlined),
                                color: Color(0xffB0B0B0),
                                iconSize: 15,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      ElevatedButton(
                        onPressed: () async {
                          //showInterstitialAd();
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GenerateIntroduction()));

                          if (result == true) {
                            _fetchIntroduction();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff03AA5A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(200, 37),
                        ),
                        child: const Text(
                          '소개 글 생성하기',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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