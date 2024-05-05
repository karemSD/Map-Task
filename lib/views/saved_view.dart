import 'dart:developer';

import 'package:apitask/models/location_api_model.dart';
import 'package:apitask/utils/global/values.dart';
import 'package:apitask/utils/services/locations_api_service.dart';
import 'package:apitask/widgets/place_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text('Saved Screen'),
        ),
        const SizedBox(
          height: 40,
        ),
        FutureBuilder<List<LocationApiModel>?>(
          future: LocationsApiService.fetchData(
              accessToken), // Replace with your async function to fetch places
          builder: (context, snapshot) {
            log(snapshot.toString());
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: appColorPrimary,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("There is no Saved Locations"),
                );
              }
              print("Done");
              final places = snapshot.data;
              return Expanded(
                child: ListView.builder(
                  itemCount: places?.length ?? 0,
                  itemBuilder: (context, index) {
                    final place = places![index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: PlaceListTile(
                            placeName: place.name,
                            longLat: place.longLat,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              );
            }
            return const Center(
              child: Text("There is no Saved Locations"),
            );
          },
        )
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: 6,
        //     itemBuilder: (context, index) {
        //       return const Column(
        //         children: [
        //           PlaceListTile(
        //               placeName: "placeName",
        //               latitude: 33.43545454,
        //               longitude: 33.43545454,
        //               details: "Famous suspension bridge in San Francisco"),
        //           SizedBox(
        //             height: 10,
        //           )
        //         ],
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }
}
