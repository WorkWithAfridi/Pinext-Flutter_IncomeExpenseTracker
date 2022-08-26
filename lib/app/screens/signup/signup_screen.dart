import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/bloc/signin_cubit/signin_cubit_cubit.dart';
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
      create: (context) => SigninCubit(),
      child: SignupScreenView(),
    );
  }
}

class SignupScreenView extends StatelessWidget {
  SignupScreenView({Key? key}) : super(key: key);

  List registrationPages = [
    const UserRegistrationPage(),
    CardsAndBalancesRegistrationPage(),
  ];

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
      body: BlocBuilder<SigninCubit, SigninState>(
        builder: (context, state) {
          return PageView.builder(
            controller: state.pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: registrationPages.length,
            itemBuilder: ((context, index) {
              return registrationPages[index];
            }),
          );
        },
      ),
    );
  }
}

class UserRegistrationPage extends StatelessWidget {
  const UserRegistrationPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
          BlocBuilder<SigninCubit, SigninState>(
            builder: (context, state) {
              return GetCustomButton(
                title: "Next",
                titleColor: whiteColor,
                buttonColor: customBlueColor,
                isLoading: false,
                callBackFunction: () {
                  state.pageController.animateToPage(
                    1,
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    curve: Curves.linear,
                  );
                },
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
    );
  }
}

class CardsAndBalancesRegistrationPage extends StatelessWidget {
  CardsAndBalancesRegistrationPage({Key? key}) : super(key: key);

  List cards = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Pinext",
              style: regularTextStyle.copyWith(
                color: customBlackColor.withOpacity(.6),
              ),
            ),
            Text(
              "Cards and Balances",
              style: boldTextStyle.copyWith(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(
                35,
              ),
              height: 180,
              width: getWidth(context),
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(
                  defaultBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Your current NET Balance is",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GetCustomTextField(
                    controller: TextEditingController(),
                    hintTitle: "Enter your current NET balance...",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Taka",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Manage Cards",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            cards.isEmpty
                ? Text(
                    "Please add a card to continue using the app!",
                    style: regularTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.4),
                    ),
                  )
                : const SizedBox.shrink(),
            ListView.builder(
              itemCount: cards.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                return Card(
                  elevation: 0,
                  shadowColor: greyColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      defaultBorder,
                    ),
                  ),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(
                        defaultBorder,
                      ),
                    ),
                    width: getWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Bkash",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: customBlackColor,
                                  ),
                                ),
                                Container(
                                  width: double.maxFinite,
                                  height: .5,
                                  color: customBlackColor.withOpacity(.2),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Current balance",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                        color: customBlackColor.withOpacity(.4),
                                      ),
                                    ),
                                    const Text(
                                      "67000Tk",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: customBlackColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: .5,
                              height: getHeight(context),
                              color: customBlackColor.withOpacity(.2),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Last transaction",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10,
                                      color: customBlackColor.withOpacity(.4),
                                    ),
                                  ),
                                  const Text(
                                    "12/12/12",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: customBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: .5,
                                  height: getHeight(context),
                                  color: customBlackColor.withOpacity(.2),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.edit,
                                      color: customBlackColor,
                                    ),
                                    Container(
                                      width: 55,
                                      height: .5,
                                      color: customBlackColor.withOpacity(.2),
                                    ),
                                    const Icon(
                                      Icons.delete,
                                      color: customBlackColor,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Add a new card",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(
                  defaultBorder,
                ),
              ),
              alignment: Alignment.center,
              width: getWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25,
                      ),
                      border: Border.all(
                        color: customBlackColor.withOpacity(.4),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: customBlackColor.withOpacity(.4),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Add a new card",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<SigninCubit, SigninState>(
              builder: (context, state) {
                return GetCustomButton(
                  title: "Back",
                  titleColor: whiteColor,
                  buttonColor: customBlueColor,
                  isLoading: false,
                  callBackFunction: () {
                    state.pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            BlocBuilder<SigninCubit, SigninState>(
              builder: (context, state) {
                return GetCustomButton(
                  title: "Register",
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
          ],
        ),
      ),
    );
  }
}
