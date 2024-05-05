
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global/values.dart';

class RoutesService {
  final String baseUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';
  final String apiKey = 'AIzaSyC87Tt3tfO6aYids0BZStXXbrdAy05jQCI';
  
  Future<List<LatLng>> getPolylinePoints(
      LatLng origin, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
            webServiceApiKey,
            PointLatLng(origin.latitude, origin.longitude),
            PointLatLng(destination.latitude, destination.longitude),
            travelMode: TravelMode.walking);
    if (polylineResult.points.isNotEmpty) {
      for (PointLatLng element in polylineResult.points) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      }
    } else {
      log("No results");
    }
    log("Worked baby");
    return polylineCoordinates;
  }

  displayRoute(List<LatLng> points) {
    return Polyline(
        polylineId: const PolylineId("value"),
        color: Colors.pink,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: points);
  }
}
