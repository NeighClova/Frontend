/*import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int current_index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current_index,
      onTap: (index) {
        /*switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/news');
            break;
          default:
        }*/
        print('index : ${index}');
        setState(() {
          current_index = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '소식생성'),
      ],
      selectedItemColor: Colors.black,
      selectedIconTheme: IconThemeData(color: Colors.black),
      unselectedItemColor: Colors.grey,
      unselectedIconTheme: IconThemeData(color: Colors.grey),
      type: BottomNavigationBarType.shifting,
    );
  }
}*/