import 'package:apitask/utils/global/values.dart';
import 'package:apitask/views/login_or_rigster_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CutsomNavigationBar extends StatefulWidget {
  const CutsomNavigationBar({super.key, required this.updateView});
  final void Function(int index) updateView;

  @override
  State<CutsomNavigationBar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CutsomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: .1,
      indicatorColor: appColorPrimary!.withOpacity(.5),
      backgroundColor: Colors.white54,
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: Icon(
            color: _selectedIndex == 0
                ? Colors.blue
                : Colors.grey, // Adjust colors as needed

            Icons.explore,
          ),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(
              color: _selectedIndex == 1
                  ? Colors.blue
                  : Colors.grey, // Adjust colors as needed

              FontAwesomeIcons.bookBookmark),
          label: 'Saved',
        ),
        NavigationDestination(
          icon: Icon(
              color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              FontAwesomeIcons.rightFromBracket),
          label: 'Log Out',
        ),
      ],
      selectedIndex: _selectedIndex,
      overlayColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue; // Blue color when pressed
          } else {
            return null; // No custom color otherwise
          }
        },
      ),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      animationDuration: const Duration(milliseconds: 300),
      onDestinationSelected: (index) {
        _onItemTapped(index);
        if (index == 2) {
          accessToken = "";
          Get.offAndToNamed(LoginOrRigsterView.id);
        }
        widget.updateView(index);
      },
    );
  }
}
