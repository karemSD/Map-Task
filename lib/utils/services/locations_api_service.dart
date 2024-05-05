import 'dart:convert';

import 'package:apitask/models/location_api_model.dart';
import 'package:apitask/utils/global/values.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class LocationsApiService {
  static String apiUrl = 'https://frontendtask.mtjrak.com/api/Locations';
  static Future<List<LocationApiModel>?>? fetchData(String token) async {
    // Define the API endpoint URL

    try {
      // Make the GET request with the token in the Authorization header
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
      );
      dev.log(response.statusCode.toString());
      // Check the response status code
      if (response.statusCode == 200) {
        // Request successful, parse the response body
        String responseBody = response.body;
        // Do something with the response data
        print(responseBody);
        List<dynamic> jsonData = jsonDecode(responseBody);
        List<LocationApiModel> places =
            jsonData.map((json) => LocationApiModel.fromJson(json)).toList();
        return places;
      } else {
        // Request failed, print error message
        print('Request failed with status: ${response.statusCode}');
        return null;

        // Do something with the response data
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
    }
    return null;
  }

  static Future<dynamic> postData(LocationApiModel locationApiModel) async {
    // Define the API endpoint URL

    String requestBodyJson = jsonEncode(locationApiModel.toJson());

    String token = accessToken;
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBodyJson,
      );

      dev.log(response.statusCode.toString());

      // Check the response status code
      if (response.statusCode == 201) {
        // Request successful, parse the response body
        String responseBody = response.body;
        // Do something with the response data
        return LocationApiModel.fromJson(jsonDecode(responseBody));
      } else {
        // Request failed, print error message
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      throw Exception(e);
    }
  }

  static Future<void> deleteLocation(String id) async {
    String url = 'https://frontendtask.mtjrak.com/api/Locations/$id';
    String token = accessToken;

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );
      dev.log(response.statusCode.toString());
      if (response.statusCode == 200) {
        print('Location deleted successfully');
      } else {
        print('Failed to delete location. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
