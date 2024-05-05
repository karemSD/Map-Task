import 'dart:math';
import 'dart:ui' as ui;
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/marker_info.dart';
import '../../models/place_autocomplete_model/place_autocomplete_model.dart';
import '../../models/place_details_model/place_details_model.dart';
import 'google_maps_places_service.dart';
import 'location_service.dart';
import 'routes_service.dart';

class MapViewService {
  GoolgeMapsPlaceService placesService = GoolgeMapsPlaceService();
  LocationService locationService = LocationService();
  RoutesService routesService = RoutesService();
  LatLng? currentLocation;

  Future<void> getPredictions(
      {required String input,
      required String sesstionToken,
      required List<PlaceModel> places}) async {
    if (input.isNotEmpty) {
      var result = await placesService.getPredictions(
          sessionToken: sesstionToken, input: input);
      dev.log(input);
      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongitude = points.first.longitude;
    var northEastLatitude = points.first.latitude;
    var northEastLongitude = points.first.longitude;

    for (var point in points) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongitude = max(northEastLongitude, point.longitude);
    }

    return LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude));
  }

  Future<Uint8List> getImagefromBytes(String image, double width) async {
    var imageData = await rootBundle.load(image);
    var imageCodec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width.round());
    var imageFrameInfo = await imageCodec.getNextFrame();
    var imageByData =
        await imageFrameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return imageByData!.buffer.asUint8List();
  }

  void moveCamerWithUpdateMarkers({
    required PlaceDetailsModel placeDetailsModel,
    required GoogleMapController controller,
    required Set<Marker> markerSet,
    required TextEditingController textController,
    required List<PlaceModel> placesList,
  }) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            placeDetailsModel.geometry!.location!.lat!,
            placeDetailsModel.geometry!.location!.lng!,
          ),
          zoom: 12,
        ),
      ),
    );
    MarkerInfoModel markerInfoModel = extractCountryAndCity(placeDetailsModel);
    addMarkerFromPlaceDetails(
        placeDetailsModel: placeDetailsModel, markerSet: markerSet);
    textController.clear();
    placesList.clear();
  }

  MarkerInfoModel extractCountryAndCity(PlaceDetailsModel placeDetailsModel) {
    String? country;
    String? city;

    // Check if address components exist
    if (placeDetailsModel.addressComponents != null) {
      // Iterate through address components
      placeDetailsModel.addressComponents!.forEach((component) {
        // Check for country component
        if (component.types!.contains('country')) {
          country = component.longName;
        }
        // Check for city component
        if (component.types!.contains('locality')) {
          city = component.longName;
        }
      });
    }

    // Print the country and city
    return MarkerInfoModel(country: country, city: city);
  }

  void addMarkerFromPlaceDetails(
      {required PlaceDetailsModel placeDetailsModel,
      required Set<Marker> markerSet,
      BitmapDescriptor? icon}) {
    // MarkerInfoModel markerInfoModel = extractCountryAndCity(placeDetailsModel);
    markerSet.add(
      Marker(
        icon: icon ?? BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
            title: placeDetailsModel.name,
            snippet:
                "${placeDetailsModel.geometry?.location?.lat}, ${placeDetailsModel.geometry?.location?.lng}"),
        markerId: MarkerId(markerSet.length.toString()),
        position: LatLng(
          placeDetailsModel.geometry!.location!.lat!,
          placeDetailsModel.geometry!.location!.lng!,
        ),
      ),
    );
    markerSet.removeWhere(
      (element) =>
          element.mapsId != const MarkerId("user_marker") &&
          element.position !=
              LatLng(
                placeDetailsModel.geometry!.location!.lat!,
                placeDetailsModel.geometry!.location!.lng!,
              ),
    );
  }
}
