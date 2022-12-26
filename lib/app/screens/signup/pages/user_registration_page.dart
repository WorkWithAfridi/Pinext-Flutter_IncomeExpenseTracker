import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../app_data/theme_data/colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_snackbar.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/socials_button.dart';

class UserRegistrationPage extends StatelessWidget {
  UserRegistrationPage({
    Key? key,
    required this.userNameController,
    required this.emailController,
    required this.passwordController,
    required this.pageController,
  }) : super(key: key);
  TextEditingController userNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  PageController pageController;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        height: getHeight(context) - kToolbarHeight,
        width: getWidth(context),
        child: Form(
          key: _formKey,
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
                height: 12,
              ),
              CustomTextFormField(
                controller: userNameController,
                hintTitle: "Enter username...",
                onChanged: (String value) {},
                validator: (value) {
                  return InputValidation(value.toString()).isCorrectName();
                },
                suffixButtonAction: () {},
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextFormField(
                controller: emailController,
                hintTitle: "Email address...",
                onChanged: (String value) {},
                validator: (value) {
                  return InputValidation(value.toString()).isCorrectEmailAddress();
                },
                suffixButtonAction: () {},
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextFormField(
                controller: passwordController,
                hintTitle: "Password",
                isPassword: true,
                onChanged: (String value) {},
                validator: (value) {
                  return InputValidation(value.toString()).isNotEmpty();
                },
                suffixButtonAction: () {},
              ),
              const SizedBox(
                height: 12,
              ),
              GetCustomButton(
                  title: "Next",
                  titleColor: whiteColor,
                  buttonColor: customBlueColor,
                  isLoading: false,
                  callBackFunction: () {
                    if (_formKey.currentState!.validate()) {
                      if (userNameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        pageController.jumpToPage(
                          1,
                        );
                      } else {
                        GetCustomSnackbar(
                          title: "....",
                          message: "You need to fill up the form to proceed to the next step!",
                          snackbarType: SnackbarType.info,
                          context: context,
                        );
                      }
                    }
                  }),
              // const SizedBox(
              //   height: 12,
              // ),
              // Text(
              //   "Or sign up using socials",
              //   style: regularTextStyle.copyWith(
              //     fontSize: 14,
              //     color: customBlackColor.withOpacity(.6),
              //   ),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // SocialsButton(),
              const SizedBox(
                height: 8,
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
      ),
    );
  }
}
