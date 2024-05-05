import 'dart:developer';

import 'package:location/location.dart';

import '../expception/exceptions.dart';

class LocationService {
  Location location = Location();

  Future<void> checkAndRequestForLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      await location.requestService();
      if (!isServiceEnabled) {
        //! the user did not give us the accept
        log("the user did not give us the accept");
        throw LocationServiceException(
            message: "Location service is not enabled.");
      }
    }
    log("inside step one $isServiceEnabled");
  }

  Future<void> checkAndRequestForPermissionLocationService() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      throw LocationPermissionException(
          message: "Location permission is denied forever.");
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // //! the user did not give us the accept
        // log("the user did not give us the Permission  ");
        throw LocationPermissionException(
            message: "Location permission is denied.");
      }
    }
    log("the user did  give us the Permission  ");
  }

  getRealTimeLocationData(
    void Function(LocationData)? onData,
  ) async {
    // Future.wait();
    await Future.wait([
      checkAndRequestForLocationService(),
      checkAndRequestForPermissionLocationService()
    ]);

    location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getLocationDataFuture() async {
    await Future.wait([
      checkAndRequestForLocationService(),
      checkAndRequestForPermissionLocationService()
    ]);
    return await location.getLocation();
  }
}
