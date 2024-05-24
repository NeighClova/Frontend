import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  }
  bool isRegistered = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}