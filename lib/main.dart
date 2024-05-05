

import 'package:apitask/views/google_map_view.dart';
import 'package:apitask/views/login_or_rigster_view.dart';
import 'package:apitask/views/login_view.dart';
import 'package:apitask/views/time_line_view.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: GoogleMapView.id, page: () => const GoogleMapView()),
        GetPage(name: TimeLine.id, page: () => const TimeLine()),
        GetPage(name: LoginOrRigsterView.id, page: () => const LoginOrRigsterView()),

      ],
      title: 'Flutter Map Demo',
      debugShowCheckedModeBanner: false,
   
       home: const LoginOrRigsterView()
    );
  }
}
