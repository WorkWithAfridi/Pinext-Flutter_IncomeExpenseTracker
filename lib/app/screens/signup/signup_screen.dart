import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/bloc/login_cubit/login_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/socials_button.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const SignupScreenView(),
    );
  }
}

class SignupScreenView extends StatelessWidget {
  const SignupScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
          ),
        ),
      ),
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
            Text(
              "Welcome",
              style: boldTextStyle.copyWith(fontSize: 30),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Please provide the following data\nto register a new account.",
              style: regularTextStyle.copyWith(
                fontSize: 14,
                color: customBlackColor.withOpacity(.6),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GetCustomTextField(
              controller: TextEditingController(),
              hintTitle: "Enter username...",
            ),
            const SizedBox(
              height: 8,
            ),
            GetCustomTextField(
              controller: TextEditingController(),
              hintTitle: "Enter email address...",
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
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return GetCustomButton(
                  title: "Next",
                  titleColor: whiteColor,
                  buttonColor: customBlueColor,
                  isLoading: false,
                  callBackFunction: () {},
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Or sign up using socials",
              style: regularTextStyle.copyWith(
                fontSize: 14,
                color: customBlackColor.withOpacity(.6),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            SocialsButton(),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: regularTextStyle.copyWith(
                        fontSize: 14,
                        color: customBlackColor.withOpacity(.6),
                      ),
                    ),
                    TextSpan(
                      text: "Sign in",
                      style: boldTextStyle.copyWith(
                        fontSize: 14,
                        color: customBlueColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
