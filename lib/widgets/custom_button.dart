import 'package:flutter/material.dart';

class CustomNextButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  final Function() onTap;
  const CustomNextButton({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Material(
        color: backgroundColor,
        elevation: 8,
        shape: CircleBorder(
          side: BorderSide(width: 2, color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            size: 30,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
