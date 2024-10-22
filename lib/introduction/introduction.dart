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
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    createInterstitialAd();
  }

  String? placeProfileImg = "";
  String? placeName = "";
  String? placeCategory = "";
  bool isProfileImgExist = false;
  final pageController = PageController();
  List<Introduces>? introduceList = [];

  static final storage = FlutterSecureStorage();
  dynamic accesstoken = '';
  dynamic placeId;
  dynamic IGName;
  dynamic IGPassword;

  bool _isLoading = false;

  InterstitialAd? _interstitialAd;

  getIntroduceAction() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    accesstoken = await storage.read(key: 'accessToken');
    placeId = await storage.read(key: 'placeId');

    // 헤더 설정
    dio.options.headers['Authorization'] = 'Bearer $accesstoken';

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

  void createInterstitialAd() {
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
  }

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
                            as ImageProvider<Object> // NetworkImage 사용
                        : AssetImage('assets/storeImg.png'), // AssetImage 사용
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
                                    IGName = await storage.read(
                                        key: placeId + 'IGName');
                                    IGPassword = await storage.read(
                                        key: placeId + 'IGPassword');
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
                                                                print(
                                                                    '인스타 업로드');
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
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
                          showInterstitialAd();
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
