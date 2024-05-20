import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neighclova/main_page.dart';
import 'package:flutter_neighclova/mypage.dart';
import 'package:flutter_neighclova/news.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});
 
  @override
  State<TabView> createState() => _TabViewState();
}
 
class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  late TabController _tabController;
  int _index = 0;
 
  @override
  void initState() {
    super.initState();
 
    _tabController = TabController(length: _navItems.length, vsync: this);
    _tabController.addListener(tabListener);
  }
 
  @override
  void dispose() {
    _tabController.removeListener(tabListener);
    super.dispose();
  }
 
  void tabListener() {
    setState(() {
      _index = _tabController.index;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff404040),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
        ),
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _tabController.animateTo(index);
        },
        currentIndex: _index,
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(
              _index == item.index ? item.activeIcon : item.inactiveIcon,
            ),
            label: item.label,
          );
        }).toList(),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [
          MainPage(),
          Center(child: Text('리뷰분석')),
          Center(child: Text('소개생성')),
          NewsPage(),
          MyPage(),
        ],
      ),
    );
  }
}
 
class NavItem {
  final int index;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
 
  const NavItem({
    required this.index,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}
 
const _navItems = [
  NavItem(
    index: 0,
    activeIcon: Icons.home,
    inactiveIcon: Icons.home,
    label: '홈',
  ),
  NavItem(
    index: 1,
    activeIcon: Icons.chat_bubble,
    inactiveIcon: Icons.chat_bubble,
    label: '리뷰분석',
  ),
  NavItem(
    index: 2,
    activeIcon: Icons.info,
    inactiveIcon: Icons.info,
    label: '소개생성',
  ),
  NavItem(
    index: 3,
    activeIcon: Icons.notifications,
    inactiveIcon: Icons.notifications,
    label: '소식생성',
  ),
  NavItem(
    index: 4,
    activeIcon: Icons.person,
    inactiveIcon: Icons.person,
    label: 'My',
  ),
];