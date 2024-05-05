import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    // required this.color
  });
  String buttonText;
  //Color color;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff103CE7),
                Color(0xff64E9FF),

               
              ]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
