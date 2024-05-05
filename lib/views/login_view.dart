import 'dart:developer';

import 'package:apitask/utils/services/auth_service.dart';
import 'package:apitask/views/time_line_view.dart';
import 'package:apitask/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../utils/global/values.dart';
import '../widgets/custom_text_field_write.dart';
import '../widgets/my_button.dart';
import '../widgets/row_divdir.dart';
import 'package:email_validator/email_validator.dart';

import 'google_map_view.dart';

class LoginView extends StatefulWidget {
 final Function()? onTap;
  const LoginView({super.key,  this.onTap});
  static String id = "/LoginView";
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> globalKey = GlobalKey();
  final userEmailController = TextEditingController();
  final passwordController = TextEditingController();
  String email = "";
  String password = "";
  bool obscureTextPassword = false;
  Future<void> signInUser(
      {required String email, required String password}) async {
    try {
      log("signInUser Start");
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      var data = await AuthService.login(email: email, password: password);
      accessToken = data['accessToken'];
      Navigator.of(context).pop();
      Get.offAndToNamed(TimeLine.id);
      // CustomSnackBar.showSuccess("Login successfully");
    } catch (e) {
      Navigator.of(context).pop();
      CustomSnackBar.showError(
          "Unauthorized : Wrong email or password provided");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // logo App
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 200,
                      child: Image.asset('assets/icons/map.png'),
                    ),
                  ),

                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Email field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: CustomWriteTextFiled(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email Can not be Empty";
                        }
                        if (!EmailValidator.validate(value)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                      textFieldType: TextFieldType.other,
                      onClear: () {
                        setState(() {
                          userEmailController.clear();
                        });
                      },
                      onChanged: (p0) {
                        email = p0;
                        setState(() {});
                      },
                      obscureText: false,
                      controller: userEmailController,
                      hinText: 'Email',
                      inputType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                    ),
                  ),

                  // password field

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: CustomWriteTextFiled(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password Can not be Empty";
                        }
                        return null;
                      },
                      textFieldType: TextFieldType.password,
                      onChanged: (p0) {
                        password = p0;
                        setState(() {});
                      },
                      onClear: () {
                        setState(() {
                          obscureTextPassword = !obscureTextPassword;
                        });
                      },
                      obscureText: obscureTextPassword,
                      controller: passwordController,
                      hinText: 'Password',
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.key,
                    ),
                  ),

                  //forget Password

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'Forget Password?',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  //Login button

                  MyButton(
                    onTap: () async {
                      if (globalKey.currentState!.validate()) {
                        await signInUser(email: email, password: password);
                      }
                    },
                    buttonText: 'Sign In',
                    // color: Colors.deepPurpleAccent,
                  ),
                  const RowDivider(text: "Don\'t have an account? "),
                  const SizedBox(
                    height: 7,
                  ),
                  // Google icon Sign in

                  // not registered make am account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Make One!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appColorPrimary,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
