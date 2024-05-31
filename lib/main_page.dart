import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/edit_info.dart';
import 'package:flutter_neighclova/register_info.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

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
    //가게 이름 세팅
    storeName = '소곤 식당';
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
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                              EditInfo())
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