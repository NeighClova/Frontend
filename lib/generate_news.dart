import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GenerateNews extends StatefulWidget {
	const GenerateNews({Key? key}) : super(key: key);

  @override
  State<GenerateNews> createState() => _GenerateNewsState();
}

class _GenerateNewsState extends State<GenerateNews> {
  @override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          )
        ),
        title: Text('소식 생성',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          )
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Padding(padding: EdgeInsets.only(top: 10)),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('가게 소식 키워드',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:Colors.black,
                                fontSize: 20,
                              )
                            ),
                            Text('어떤 소식을 작성하시겠어요?',
                              style: TextStyle(
                                color:Colors.grey,
                                fontSize: 15,
                              )
                            ),
                          ]
                        ),
                        Tooltip(
                          child: Icon(
                            Icons.info,
                            size: 30,
                            color: Color(0xff03AA5A),
                          ),
                          message: '주의해주세요!\n'
                                    '- 사실이 아닌 일을 출력할 수도 있어요.\n'
                                    '- 활용 전 사실 점검을 권장드려요.\n'
                                    '- 구체적으로 지시할수록 더 좋은 답변을 얻을 수 있어요.',
                          padding: EdgeInsets.all(20),
                          textStyle: TextStyle(color: Colors.black),
                          preferBelow: false,
                          verticalOffset: 15,
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ]
          )
        )
      )
		);
	}
}