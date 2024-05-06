import 'dart:async';
import 'dart:developer' as dev;
import 'package:apitask/models/location_api_model.dart';
import 'package:apitask/models/place_details_model/place_details_model.dart';
import 'package:apitask/utils/global/values.dart';
import 'package:apitask/widgets/bottom_sheet_body.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:uuid/uuid.dart';
import '../models/place_autocomplete_model/place_autocomplete_model.dart';
import '../utils/expception/exceptions.dart';
import '../utils/services/google_maps_places_service.dart';
import '../utils/services/map_view_Service.dart';
import '../utils/services/routes_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_listview_predictions.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text_fiield.dart';
import '../widgets/navigation_bar.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key, this.savedLocation});
  static String id = "/GoogleMapView";
  final LocationApiModel? savedLocation;
  @override
  State<GoogleMapView> createState() => GoogleMapViewState();
}

class GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition cameraPosition;
  late MapViewService mapViewService;
  late RoutesService routeService;
  late GoogleMapController googleMapController;
  late GoolgeMapsPlaceService goolgeMapsPlaceService;
  late BitmapDescriptor customMarkerUserIcon;
  late BitmapDescriptor customMarkerStarIcon;
  late TextEditingController textEditingController;
  late LatLng currentPosition;
  late LatLng destintion;
  late Uuid uuid;
  String? sesstionToken;
  Timer? debounce;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<PlaceModel> places = [];
  LatLngBounds? bounds;
  @override
  void initState() {
    super.initState();

    initlizeVariables();
    initMarkersIcon();
    if (widget.savedLocation != null) {
      addMarkerAtSavedLocation();
    }

    fetchPredicitions();
    dev.log("GoogleMapView");
  }

  initMarkersIcon() async {
    customMarkerUserIcon = BitmapDescriptor.fromBytes(await mapViewService
        .getImagefromBytes("assets/icons/google-maps.png", 70));

    customMarkerStarIcon = BitmapDescriptor.fromBytes(
        await mapViewService.getImagefromBytes("assets/icons/map-mrk.png", 70));
  }

  @override
  void dispose() {
    textEditingController.dispose();
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            onTap: (tappedPoint) {
              markers.add(
                Marker(
                  markerId: MarkerId(tappedPoint.toString()),
                  position: tappedPoint,
                  infoWindow: InfoWindow(
                    title: " ${tappedPoint.latitude}, ${tappedPoint.longitude}",
                  ),
                  onTap: () async {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      double.parse(tappedPoint.latitude.toStringAsFixed(7)),
                      double.parse(
                        tappedPoint.longitude.toStringAsFixed(7),
                      ),
                    );

                    LocationApiModel locationApiModel = LocationApiModel(
                        id: 0,
                        name:
                            "${placemarks[0].country} , ${placemarks[0].administrativeArea} ,${placemarks[0].subAdministrativeArea} , ${placemarks[0].street}",
                        longLat:
                            "${tappedPoint.latitude},${tappedPoint.longitude}");
                    showLocationButtomSheet(locationApiModel, tappedPoint);

                    // print(placemarks);
                  },
                ),
              );
              markers.removeWhere((element) =>
                  element.mapsId != const MarkerId("user_marker") &&
                  element.position != tappedPoint);
              if (mounted) {
                setState(() {});
              }
            },
            polylines: polylines,
            markers: markers,
            onMapCreated: (controller) async {
              googleMapController = controller;
              await updateCurrentLocation();
            },
            zoomControlsEnabled: false,
            initialCameraPosition: cameraPosition,
          ),
          Positioned(
              right: 20,
              bottom: 70,
              child: CustomNextButton(
                  icon: FontAwesomeIcons.locationCrosshairs,
                  iconColor: appColorPrimary!,
                  backgroundColor: Colors.white,
                  borderColor: Colors.white,
                  onTap: () {
                    googleMapController
                        .animateCamera(CameraUpdate.newLatLng(currentPosition));
                  })),
          Positioned(
            top: 25,
            left: 20,
            right: 20,
            child: Column(
              children: [
                CustomSearchTextFiled(
                    onClear: () {
                      textEditingController.clear();
                      places.clear();
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    hinText: "Search here",
                    inputType: TextInputType.text,
                    prefixIcon: Icons.map_outlined,
                    obscureText: false,
                    controller: textEditingController),
                const SizedBox(
                  height: 8,
                ),
                CustomListVewPredictions(
                    onPlaceSelect: (placeDetailsModel) {
                      mapViewService.moveCamerWithUpdateMarkers(
                          placeDetailsModel: placeDetailsModel,
                          controller: googleMapController,
                          markerSet: markers,
                          placesList: places,
                          textController: textEditingController);
                      sesstionToken = null;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    onPlaceSelectDirections: (placeDetailsModel) async {
                      textEditingController.clear();
                      places.clear();
                      sesstionToken = null;
                      await showRouteWithMarker(placeDetailsModel);
                      if (mounted) {
                        setState(() {});
                      }

                      print("routess");
                    },
                    places: places,
                    goolgeMapsPlaceService: goolgeMapsPlaceService)
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> showRouteWithMarker(PlaceDetailsModel placeDetailsModel) async {
    destintion = LatLng(placeDetailsModel.geometry!.location!.lat!,
        placeDetailsModel.geometry!.location!.lng!);
    List<LatLng> points =
        await routeService.getPolylinePoints(currentPosition, destintion);
    mapViewService.addMarkerFromPlaceDetails(
        placeDetailsModel: placeDetailsModel,
        markerSet: markers,
        icon: customMarkerStarIcon);
    updatePolylineSet(points);
  }

  Future<void> showRoute(LatLng destintion, LatLng currentPosition) async {
    List<LatLng> points =
        await routeService.getPolylinePoints(currentPosition, destintion);
    updatePolylineSet(points);
  }

  updateCurrentLocation() {
    try {
      mapViewService.locationService.location.changeSettings(distanceFilter: 5);
      mapViewService.locationService.getRealTimeLocationData((locationData) {
        print("object");
        var currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
        currentPosition =
            LatLng(currentLocation.longitude, currentLocation.longitude);
        globalcurrentPosition = currentPosition;
        Marker userMarker = Marker(
          markerId: const MarkerId("user_marker"),
          infoWindow: const InfoWindow(snippet: "", title: "الموقع الحالي"),
          icon: customMarkerUserIcon,
          position: currentPosition,
        );
        markers.add(userMarker);

//!
        if (bounds != null) {
          // Animate camera to fit bounds
          googleMapController.animateCamera(
            CameraUpdate.newLatLngBounds(bounds!, 25),
          );
        } else {
          // Use default camera position logic
          CameraPosition myCurrentCameraPosition = CameraPosition(
            zoom: 16,
            target: currentPosition,
          );
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(myCurrentCameraPosition),
          );
        }
        if (mounted) {
          setState(() {});
        }
      });
    } on LocationServiceException catch (e) {
      CustomSnackBar.showError(e.message);
    } on LocationPermissionException catch (e) {
      CustomSnackBar.showError(e.message);
    } catch (e) {
      CustomSnackBar.showError(e.toString());
    }
  }

  void initlizeVariables() {
    mapViewService = MapViewService();
    if (widget.savedLocation == null) {
      cameraPosition = CameraPosition(target: const LatLng(0, 0));
    } else {
      List<String> coordinates = widget.savedLocation!.longLat.split(',');
      double latitude = double.parse(coordinates[0]);
      double longitude = double.parse(coordinates[1]);
      cameraPosition = CameraPosition(target: LatLng(latitude, longitude));
    }

    textEditingController = TextEditingController();
    goolgeMapsPlaceService = GoolgeMapsPlaceService();
    uuid = const Uuid();
    routeService = RoutesService();
  }

  void fetchPredicitions() {
    textEditingController.addListener(() async {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }

      debounce = Timer(const Duration(milliseconds: 200), () async {
        sesstionToken ??= uuid.v4();
        mapViewService.getPredictions(
            input: textEditingController.text,
            sesstionToken: sesstionToken!,
            places: places);
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  void updatePolylineSet(List<LatLng> points) {
    polylines.add(routeService.displayRoute(points));
    bounds = mapViewService.getLatLngBounds(points);
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(bounds!, 20));
    if (mounted) {
      setState(() {});
    }
  }

  void addMarkerAtSavedLocation() async {
    List<String> coordinates = widget.savedLocation!.longLat.split(',');
    double latitude = double.parse(coordinates[0]);
    double longitude = double.parse(coordinates[1]);
    Marker marker = Marker(
      markerId: MarkerId("savedLocationMarker"),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
          title: widget.savedLocation!.name,
          snippet: widget.savedLocation!.longLat),
      onTap: () {
        showLocationButtomSheet(
          widget.savedLocation!,
          LatLng(latitude, longitude),
        );
      },
    );
    List<LatLng> points = await routeService.getPolylinePoints(
        globalcurrentPosition!, LatLng(latitude, longitude));
    updatePolylineSet(points);
    markers.add(marker);
    setState(() {});
  }

  showLocationButtomSheet(
      LocationApiModel locationApiModel, LatLng tappedPoint) {
    showModalBottomSheet(
      elevation: .2,
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: true,
      showDragHandle: true,
      scrollControlDisabledMaxHeightRatio: .2,
      context: context,
      builder: (context) {
        return BottomSheetBody(
            locationApiModel: locationApiModel,
            onDirections: () async {
              await showRoute(tappedPoint, currentPosition);
              if (mounted) {
                setState(() {});
              }
            });
      }, // Replace with your container definition
    );
  }
}
