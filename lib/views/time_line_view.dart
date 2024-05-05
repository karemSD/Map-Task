import 'package:apitask/views/google_map_view.dart';
import 'package:flutter/material.dart';

import '../utils/global/values.dart';
import '../widgets/navigation_bar.dart';
import 'saved_view.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});
  static String id = "/TimeLine";
  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  int selectedIndex = 0;
  Widget _currentScreen =
      const GoogleMapView(); // Assuming you have an ExploreScreen widget

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          _currentScreen = const GoogleMapView();
          break;
        case 1:
          _currentScreen = const SavedView();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CutsomNavigationBar(
        updateView: onItemTapped,
      ),
      appBar: AppBar(
        backgroundColor: appColorPrimary,
        centerTitle: true,
        title: const Text("Find"),
      ),
      body: _currentScreen,
    );
  }
}
