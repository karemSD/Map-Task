import 'dart:developer';

import 'package:apitask/api.dart';
import 'package:apitask/utils/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../utils/global/values.dart';
import 'custom_snackbar.dart';
import 'custom_text_field_write.dart';
import 'my_button.dart';
import 'package:email_validator/email_validator.dart';

import 'row_divdir.dart';

class RigsterViewBody extends StatefulWidget {
  RigsterViewBody({super.key, required this.onTap});

  Function()? onTap;

  @override
  State<RigsterViewBody> createState() => _RigsterViewBodyState();
}

class _RigsterViewBodyState extends State<RigsterViewBody> {
  final userEmailController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey();

  String password = "";
  String email = "";
  String confirm = "";
  bool obscureTextPassword = false;
  bool obscureTextPasswordConfirm = false;
  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");
  RegExp regNonAlphanumeric = RegExp(r'[^\w]');

  Future<void> signUpUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (confirmPasswordController.text == passwordController.text) {
        Map<String, dynamic> responseData =
            await AuthService.register(email, password);
        Api().handleStatusCode(responseData, "Register Seccessfuly");
      } else {
        CustomSnackBar.showError('password and confirm password not the same');
      }
      Navigator.pop(context);
    } catch (ex) {
      CustomSnackBar.showError(ex.toString());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: globalKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SizedBox(
                width: 200,
                child: Image.asset('assets/icons/map.png'),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Email field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: CustomWriteTextFiled(
                textFieldType: TextFieldType.other,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "email Can not be Empty";
                  }
                  if (!EmailValidator.validate(value)) {
                    return "Enter valid email";
                  }

                  return null;
                },
                onClear: () {
                  setState(() {
                    email = "";
                    userEmailController.clear();
                  });
                },
                onChanged: (p0) {
                  email = p0;
                  setState(() {});
                },
                isDense: true,
                obscureText: false,
                controller: userEmailController,
                hinText: 'Email',
                inputType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
              ),
            ),
            // password field

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: CustomWriteTextFiled(
                textFieldType: TextFieldType.password,
                onChanged: (p0) {
                  setState(() {
                    password = p0;
                  });
                },
                onClear: () {
                  setState(() {
                    obscureTextPassword = !obscureTextPassword;
                  });
                },
                isDense: true,
                obscureText: obscureTextPassword,
                controller: passwordController,
                hinText: 'Password',
                inputType: TextInputType.visiblePassword,
                prefixIcon: Icons.key,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password Can not be Empty";
                  }
                  if (value.length < 10) {
                    return "password at least should be 8 ";
                  }
                  if (regExletters.hasMatch(value) == false) {
                    return "please enter at least one small character";
                  }
                  if (regExnumbers.hasMatch(value) == false) {
                    return "please enter at least one Number";
                  }
                  if (regExbigletters.hasMatch(value) == false) {
                    return "please enter at least one Big character";
                  }
                  if (regNonAlphanumeric.hasMatch(value) == false) {
                    return "Password must contain at least one non-alphanumeric character.";
                  }

                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: CustomWriteTextFiled(
                textFieldType: TextFieldType.password,
                validator: (value) {
                  if (confirm != password) {
                    return "Should be same as password";
                  }

                  return null;
                },
                onClear: () {
                  setState(() {
                    obscureTextPasswordConfirm = !obscureTextPasswordConfirm;
                    log("dodo");
                  });
                },
                onChanged: (p0) {
                  confirm = p0;
                  setState(() {});
                },
                isDense: true,
                obscureText: obscureTextPasswordConfirm,
                controller: confirmPasswordController,
                hinText: 'Confirm Password',
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

            //Login button

            MyButton(
              onTap: () async {
                if (globalKey.currentState!.validate()) {
                  await signUpUser();
                }
              },
              buttonText: 'Sign Up',
              // color: Colors.deepPurpleAccent,
            ),

            const RowDivider(text: "Already have an account? "),

            // Google icon Sign in

            const SizedBox(
              height: 17,
            ),
            // not registered make am account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Login Now!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appColorPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
