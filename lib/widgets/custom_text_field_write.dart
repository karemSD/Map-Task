import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TextFieldType { password, other }

class CustomWriteTextFiled extends StatelessWidget {
  const CustomWriteTextFiled({
    Key? key,
    required this.hinText,
    required this.inputType,
    required this.prefixIcon,
    this.isDense = false,
    required this.obscureText,
    required this.controller,
    this.onClear,
    required this.onChanged,
    required this.textFieldType,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hinText;
  final TextInputType? inputType;
  final IconData? prefixIcon;
  final bool? isDense;
  final bool obscureText;
  final TextFieldType textFieldType;
  final Function(String)? onChanged;
  final void Function()? onClear;
  final String? Function(String?)? validator;

  OutlineInputBorder _buildBorder({
    required BorderRadius borderRadius,
    required BorderSide borderSide,
  }) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      obscureText: obscureText,
      onChanged: onChanged,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        suffixIcon: controller.text.isNotEmpty
            ? textFieldType == TextFieldType.password
                ? obscureText
                    ? IconButton(
                        icon: const Icon(FontAwesomeIcons.eyeSlash),
                        onPressed: onClear)
                    : IconButton(
                        icon: const Icon(FontAwesomeIcons.eye),
                        onPressed: onClear)
                : IconButton(
                    onPressed: onClear,
                    icon: const Icon(FontAwesomeIcons.solidCircleXmark))
            : null,
        contentPadding: EdgeInsets.zero,
        border: _buildBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: _buildBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: _buildBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(prefixIcon),
        errorBorder: _buildBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red),
        ),
        hintText: hinText,
        fillColor: Colors.white,
        filled: true,
        isDense: isDense,
      ),
    );
  }
}
