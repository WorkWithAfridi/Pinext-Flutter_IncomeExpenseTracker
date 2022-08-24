import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/colors.dart';
import 'package:pinext/app/app_data/domentions.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        height: getHeight(context),
        width: getWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sign In\nTo Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: customBlackColor,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Please sign in with your email and password\nto continue using the app.",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: customBlackColor.withOpacity(.6),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GetCustomTextField(
              controller: TextEditingController(),
              hintTitle: "Username or email",
            ),
            const SizedBox(
              height: 8,
            ),
            GetCustomTextField(
              controller: TextEditingController(),
              hintTitle: "Password",
            ),
            const SizedBox(
              height: 16,
            ),
            const GetCustomButton(
              title: "Sign In",
              titleColor: whiteColor,
              buttonColor: customBlueColor,
            ),
            const SizedBox(
              height: 8,
            ),
            const GetCustomButton(
              title: "Sign in with Apple ID",
              titleColor: whiteColor,
              buttonColor: Colors.black,
              icon: Icons.apple,
            )
          ],
        ),
      ),
    );
  }
}
