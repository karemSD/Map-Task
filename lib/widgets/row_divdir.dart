import 'package:flutter/material.dart';

class RowDivider extends StatelessWidget {
final  String text;

  const RowDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(text),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
