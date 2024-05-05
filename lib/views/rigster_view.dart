import 'package:apitask/widgets/rigster_view_body.dart';
import 'package:flutter/material.dart';

class RigsterView extends StatelessWidget {
  final VoidCallback onTap;

  const RigsterView({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(child: RigsterViewBody(onTap: onTap)),
    );
  }
}
