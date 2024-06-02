import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/edit_info.dart';
import 'package:flutter_neighclova/mypage.dart';
import 'package:flutter_neighclova/register_info.dart';
import 'dart:ui';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

//가게들 넘겨받기(임시로 String으로 해놓음)
 List<Store> stores = [];
 int selectedIndex = 0;

 final GlobalKey _containerKey = GlobalKey();
 double _containerHeight = 0;

 void _updateContainerHeight(StateSetter bottomState) {
    final RenderBox? renderBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _containerHeight = renderBox.size.height;
      });
    }
    print('컨테이터 크기 : ${_containerHeight}');
  }

  @override
  void initState() {
    super.initState();
    //빌드 완료 후
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isRegistered)
      {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
            RegisterInfo())
        );
      }
    });
    //현재 가게 이름 세팅
    storeName = '소곤 식당';

    //전체 가게 이름
    stores.addAll([Store('소곤 식당', 'assets/storeImg.png'), Store('소곤 카페', ''), Store('망한 식당', '')]);

    //바텀시트 가게 선택 상태


     //WidgetsBinding.instance.addPostFrameCallback((_) => );
  }
  bool isRegistered = false;
  String storeName = '';

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
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 67,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(storeName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff404040),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder: (BuildContext context, StateSetter bottomState) {
                                WidgetsBinding.instance.addPostFrameCallback((_) => _updateContainerHeight(bottomState));
                                void onButtonPressed(int index) {
                                  storeName = stores[index].storeName;
                                  bottomState(() {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  });
                                  Navigator.pop(context);
                                  (context as Element).reassemble();
                                }
                                return Container(
                                  height: 114 + 64.0 * (stores.length + 1),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xffF9FFE1),
                                        Color(0xffFFEDED),
                                        Color(0xffFDF6FF),
                                        Color(0xffFCFFE9),
                                        Color(0xffEAFFF5),
                                        Color(0xffF0FBFF),
                                      ]
                                    ),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 23),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 5,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 17),),
                                        Container(
                                          key: _containerKey,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Flexible(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: stores.length + 1,
                                              itemBuilder: (context, index) {
                                                if (index == stores.length) {
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor: Color(0xffF2F2F2),
                                                      child: ClipOval(
                                                        child: Icon(Icons.add, color: Color(0xff656565)),
                                                      ),
                                                    ),
                                                    title: TextButton(
                                                      onPressed: () {
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => RegisterInfo()
                                                          ),
                                                        );
                                                      },
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          '내 업체 추가',
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: null,
                                                  );
                                                }
                                                else {
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor: Colors.grey[400],
                                                      child: ClipOval(
                                                        child: stores[index].imgUrl != ''
                                                        ? Image.asset(stores[index].imgUrl,
                                                            fit: BoxFit.cover,
                                                            width: double.infinity,
                                                            height: double.infinity,
                                                          )
                                                        : Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                          )
                                                      ),
                                                    ),
                                                    title: TextButton(
                                                      onPressed: () => onButtonPressed(index),
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(stores[index].storeName,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),),
                                                      )
                                                    ),
                                                    trailing: selectedIndex == index ? Icon(Icons.check_circle, color: Color(0xff468F4F)) : null,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 11),),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                    MyPage())
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              side: BorderSide(
                                                color: Color(0xff878787),
                                                width: 0.3,
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Text('내 업체 정보 페이지로 이동',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            }
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('업체 변경하기',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff949494),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                              color: Color(0xff949494),
                              size: 20,
                            ),
                          ],
                        ),
                        style: ButtonStyle(
                          alignment: Alignment.centerRight,
                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('우리 가게 대표 키워드',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff404040),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 4)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('CLOVA AI가 매장 리뷰를 분석해서 뽑은 키워드예요.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff949494),
                          ),
                        ),
                      ),
                      /*Expanded(
                        
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Store{
  String storeName;
  String imgUrl;
  Store(this.storeName, this.imgUrl);
}