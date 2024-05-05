import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/place_autocomplete_model/place_autocomplete_model.dart';
import '../models/place_details_model/place_details_model.dart';
import '../utils/services/google_maps_places_service.dart';

class CustomListVewPredictions extends StatelessWidget {
  const CustomListVewPredictions({
    super.key,
    required this.places,
    required this.goolgeMapsPlaceService,
    required this.onPlaceSelectDirections,
    required this.onPlaceSelect
  });
  final GoolgeMapsPlaceService goolgeMapsPlaceService;
  final List<PlaceModel> places;
  final void Function(PlaceDetailsModel) onPlaceSelectDirections;
  final void Function(PlaceDetailsModel) onPlaceSelect;
  //final PlaceDetailsModel placeDetailsModel;
  @override
  Widget build(BuildContext context) {
    return places.isEmpty
        ? const SizedBox
            .shrink() // Return an empty widget when the list is empty:
        : Container(
            color: Colors.white.withOpacity(.8),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                    trailing: IconButton(
                        onPressed: () async {
                          log("work");
                          var placedeatils = await goolgeMapsPlaceService
                              .getPlaceDetails(placeId: places[index].placeId!);
                          onPlaceSelectDirections(placedeatils);
                        },
                        icon: const Icon(FontAwesomeIcons.mapLocationDot)),
                    leading: IconButton(
                      icon: const Icon(FontAwesomeIcons.mapPin),
                      onPressed: () async{
                        log("ok1");
                              var placedeatils = await goolgeMapsPlaceService
                              .getPlaceDetails(placeId: places[index].placeId!);
                                onPlaceSelect(placedeatils);
                        log("ok2");

                      },
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    title: Text(places[index].description));
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 0,
                );
              },
              itemCount: places.length,
            ),
          );
  }
}
