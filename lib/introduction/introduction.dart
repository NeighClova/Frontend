import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/introduction/generate_introduction.dart';
import 'package:flutter_neighclova/introduction/introduction_response.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  }

  String? placeProfileImg = "";
  String? placeName = "";
  String? placeCategory = "";
  bool isProfileImgExist = false;
  final pageController = PageController();
  List<Introduces>? introduceList = [];

  static final storage = FlutterSecureStorage();
  dynamic accesstoken = '';

  getIntroduceAction() async {
    var dio = Dio();
    dio.options.baseUrl = 'http://10.0.2.2:8080';
    accesstoken = await storage.read(key: 'token');

    // 헤더 설정
    dio.options.headers['Authorization'] = 'Bearer $accesstoken';

    // 파라미터 설정
    Map<String, dynamic> queryParams = {
      'placeId': 1,
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
        });

        return;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
                        ? AssetImage(placeProfileImg!)
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
                        placeName ?? ' ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        placeCategory ?? ' ',
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
                          child: Positioned.fill(
                              child: isProfileImgExist
                                  ? Image.asset(placeProfileImg!,
                                      fit: BoxFit.cover)
                                  : const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )),
                        ),
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
                                child: PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  controller: pageController,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: introduceList?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    var introduces = introduceList?[index];
                                    return SingleChildScrollView(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 20, 20, 20),
                                      child: Text(
                                        introduces?.content ?? ' ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff404040)),
                                      ),
                                    );
                                  },
                                ),
                              )),
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
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                int currentPage =
                                    pageController.page?.round() ?? 0;
                                var introduces = introduceList?[currentPage];
                                String currentText = introduces?.content ?? ' ';
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
                            /*child: SizedBox(
                            width: 55,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: 
                            ),
                          ),*/
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GenerateIntroduction()));
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
