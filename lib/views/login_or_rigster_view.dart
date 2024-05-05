import 'package:apitask/views/rigster_view.dart';
import 'package:flutter/material.dart';

import 'login_view.dart';
import '../widgets/rigster_view_body.dart';

class LoginOrRigsterView extends StatefulWidget {
  const LoginOrRigsterView({super.key});

  @override
  State<LoginOrRigsterView> createState() => _LoginOrRigsterPageState();
}

class _LoginOrRigsterPageState extends State<LoginOrRigsterView> {
  bool showLoginPage = true;

  //

  void movePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginView(
        onTap: movePages,
      );
    } else {
      return RigsterView(
        onTap: movePages,
      );
    }
  }
}
