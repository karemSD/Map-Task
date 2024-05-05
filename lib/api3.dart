import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Api3 {
  Future<dynamic> post({
    required String url,
    @required dynamic body,
    required  Map<String, String> headers,
     String? token
  }) async {

    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    
   http.Response response = await http.post(
  Uri.parse(url),
  body: body,
  headers: headers,
);

    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          "there is a problme with status code ${response.statusCode} and  ${jsonDecode(response.body)}");
    }
  }

  Future<dynamic> put(
      {required String url,
      @required dynamic body,
      @required String? token}) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    http.Response response = await http.put(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          "there is a problme with status code ${response.statusCode} and  ${jsonDecode(response.body)}");
    }
  }

  Future<dynamic> get({required String url, String? token}) async {
    Map<String, String> headers = {};

    // if (token != null) {
    //   headers.addAll({'Authorization': 'Bearer $token'});
    // }

    print(url);

    //print(headers);
    http.Response response = await http.get(
      Uri.parse(url),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "there is a problme with status code ${response.statusCode}");
    }
  }
}
