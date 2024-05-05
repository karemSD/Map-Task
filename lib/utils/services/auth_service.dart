import 'dart:convert';

import 'package:apitask/api.dart';
import 'package:either_dart/either.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

typedef EitherException<T> = Future<Either<Exception, T>>;

class AuthService extends GetxController {
  static EitherException<bool> createUserWithEmailAndPassword({
    required String email,
    required password,
  }) async {
    try {
      await register(email, password);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  static Future<Map<String, dynamic>> login(
      {required String email,
      required String password,
      String? twoFactorCode,
      String? twoFactorRecoveryCode}) async {
    const String url = 'https://frontendtask.mtjrak.com/login';
    final Map<String, String> data = {
      'email': email,
      'password': password,
      'twoFactorCode': twoFactorCode ?? "",
      'twoFactorRecoveryCode': twoFactorRecoveryCode ?? "",
    };
    // Make the POST request
    final String encodedData = jsonEncode(data);

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'accept': 'application/json', // Make sure to include accept header
    };
    var dataResponse =
        await Api().post(url: url, body: encodedData, headers: headers);
    return dataResponse;
  }

  static Future<void> logOut() async {}

  static Future<dynamic> register(String email, String password) async {
    // Define the API endpoint
    const String url = 'https://frontendtask.mtjrak.com/register';

    // Define the request body
    final Map<String, String> data = {
      'email': email,
      'password': password,
    };

    // Encode the request body as JSON
    final String encodedData = jsonEncode(data);
    // Make the POST request

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };

    var response =
        await Api().post(url: url, body: encodedData, headers: headers);
    print(response.runtimeType);
    return response;
  }
}
