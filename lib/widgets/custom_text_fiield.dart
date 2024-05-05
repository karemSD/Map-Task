import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSearchTextFiled extends StatelessWidget {
  const CustomSearchTextFiled({
    super.key,
    required this.hinText,
    required this.inputType,
    required this.prefixIcon,
    this.isDense = false,
    required this.obscureText,
    required this.controller,
    this.onClear,
  });
  final TextEditingController controller;
  final String? hinText;
  final TextInputType? inputType;
  final IconData? prefixIcon;
  final bool? isDense;
  final bool obscureText;
  final void Function()? onClear;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(FontAwesomeIcons.solidCircleXmark),
                onPressed: onClear)
            : null,
        contentPadding: EdgeInsets.zero,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(prefixIcon),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        hintText: hinText,
        fillColor: Colors.white,
        filled: true,
        isDense: isDense,
      ),
    );
  }
}
