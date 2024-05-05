import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'widgets/custom_snackbar.dart';

class Api {
  Future<dynamic> get({required String url, String? token}) async {
    Map<String, String> headers = {};

    if (token != null) {
      headers.addAll({
        'accept': 'text/plain',
        'Authorization': 'Bearer $token',
      });
    }

    print(url);

    //print(headers);
    http.Response response = await http.get(Uri.parse(url),
        headers: headers.isEmpty ? null : headers);
    dev.log(response.body.toString());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "there is a problme with status code ${response.statusCode}");
    }
  }

  Future<dynamic> post(
      {required String url,
      @required dynamic body,
      required Map<String, String> headers,
      String? token
      //@required String? token
      }) async {
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    // print(response.bo  dy); // Print the response body

    dev.log(response.statusCode.toString());
    if (response.statusCode == 200) {
      // Check if response body is not empty
      if (response.body.isNotEmpty) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Response body is empty.');
        return {"status": 200};
      }
    } else {
      return jsonDecode(response.body);
    }
  }

  List<String> extractErrors(Map<String, dynamic> responseData) {
    List<String> errors = [];

    if (responseData['errors'] != null) {
      responseData['errors'].forEach((key, value) {
        value.forEach((element) {
          errors.add(element.toString());
        });
      });
    }

    return errors;
  }

  String formatApiErrors(Map<String, dynamic> responseData) {
    List<String> errors = extractErrors(responseData);
    String formattedErrors = "";
    for (int i = 0; i < errors.length; i++) {
      var element = errors[i];
      if (i == errors.length - 1) {
        formattedErrors += " $element ";
      } else {
        formattedErrors += " $element \n";
      }
    }

    return formattedErrors;
  }

  void handleStatusCode(
      Map<String, dynamic> responseData, String successMessage) {
    if (responseData['status'] != 200) {
      if (responseData['errors'] != null) {
        String ms = Api().formatApiErrors(responseData);
        CustomSnackBar.showError(ms);
      }
    } else {
      CustomSnackBar.showSuccess(successMessage);
    }
  }
}
