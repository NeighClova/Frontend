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
      body: Center(
        child: Text('소식 생성'),
      ),
		);
	}
}