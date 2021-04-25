import 'package:fauna_frontend/pages/map.dart';
import 'package:fauna_frontend/pages/profile.dart';
import 'package:fauna_frontend/widgets/navbar.dart';
import 'package:flutter/material.dart';

class MainScreenWidget extends StatefulWidget {
  MainScreenWidget({Key key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;
  List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      MapScreen(
        key: PageStorageKey("MapScreen")
      ),
      ProfileScreen(
        key: PageStorageKey("ProfileScreen")
      )
    ];
  } 

  Widget _bottomNavBar() {
    return Nav(
      selectedIndex: _selectedIndex,
      onChange: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: _bottomNavBar(),
      body: PageStorage(
        child: _pages[_selectedIndex],
        bucket: bucket
      )
    );
  }
}
