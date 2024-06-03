import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class License extends StatelessWidget {
	const License({Key? key}) : super(key: key);

  @override
	Widget build(BuildContext context) {
    final List<Map<String, String>> licenses = [
      {'license': '라이선스', 'content': '상세내용'},
      {'license': '라이선스2', 'content': '상세내용2'},
      {'license': '라이선스3', 'content': '상세내용3'},
    ];
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
        title: Text('오픈소스 라이선스',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff404040),
            fontSize: 20,
          )
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(licenses.length, (index){
              return Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      licenses[index]['license']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      licenses[index]['content']!,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
          })
        ),
      ),
		);
	}
}