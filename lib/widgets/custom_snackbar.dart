import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static void showSuccess(String message) {
    Get.snackbar(
      boxShadows: [
        BoxShadow(
          blurStyle: BlurStyle.outer,
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
      "Success",
      message,
      backgroundColor: Colors.greenAccent.withOpacity(.65),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showError(String message) {
    Get.snackbar(
      "Error",
      message,
      boxShadows: [
        BoxShadow(
          blurStyle: BlurStyle.outer,
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
      duration: const Duration(seconds: 20),
      backgroundColor: Colors.red.withOpacity(.65),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
