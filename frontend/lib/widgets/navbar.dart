import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class Nav extends StatefulWidget {
  final int selectedIndex;
  final Function onChange;

  Nav({Key? key, required this.selectedIndex, required this.onChange})
      : super(key: key);

  @override
  _Nav createState() => _Nav();
}

class _Nav extends State<Nav> {
  @override
  Widget build(BuildContext context) {
    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        barBackgroundColor: Colors.white,
        selectedItemBorderColor: Colors.indigo[300],
        selectedItemBackgroundColor: Colors.indigo[400],
        selectedItemIconColor: Colors.white,
        selectedItemLabelColor: Colors.black,
      ),
      selectedIndex: widget.selectedIndex,
      onSelectTab: widget.onChange,
      items: [
        FFNavigationBarItem(
          iconData: Icons.map,
          label: 'Map',
        ),
        FFNavigationBarItem(
          iconData: Icons.location_pin,
          label: 'Report',
        ),
        FFNavigationBarItem(
          iconData: Icons.notifications,
          label: 'Alerts',
        ),
        FFNavigationBarItem(
          iconData: Icons.settings,
          label: 'Profile',
        ),
      ],
    );
  }
}
