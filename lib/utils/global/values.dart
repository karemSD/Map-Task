import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String webServiceApiKey = "AIzaSyA1VJ-tARxGGgoVeJUt3DedBOeVZbYlQPo";
Color? appColorPrimary =
    Color.lerp(const Color(0xff103CE7), const Color(0xff64E9FF), 0.7);
String accessToken = "";
LatLng? globalcurrentPosition;
