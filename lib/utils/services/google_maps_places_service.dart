import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api.dart';
import '../../models/place_autocomplete_model/place_autocomplete_model.dart';
import '../../models/place_details_model/place_details_model.dart';
import '../global/values.dart';

class GoolgeMapsPlaceService {
  String baseUrlPlace = "https://maps.googleapis.com/maps/api/place";
  Future<List<PlaceModel>> getPredictions(
      {required String input, required String sessionToken}) async {
    var responseData = await Api().get(
      url:
          "$baseUrlPlace/autocomplete/json?key=$webServiceApiKey&sessionToken=$sessionToken&input=$input",
    );
    // log(responseData.toString());
    var predictionsData = responseData['predictions'];
    // print(predictionsData);
    List<PlaceModel> places = [];
    for (var item in predictionsData) {
      places.add(PlaceModel.fromJson(item));
    }
    log(places.length.toString());
    return places;
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    var responseData = await Api().get(
      url: "$baseUrlPlace/details/json?key=$webServiceApiKey&place_id=$placeId",
    );
    // log(responseData.toString());
    var resultData = responseData['result'];
    // print(predictionsData);

    log(resultData.length.toString());
    return PlaceDetailsModel.fromJson(resultData);
  }
}
