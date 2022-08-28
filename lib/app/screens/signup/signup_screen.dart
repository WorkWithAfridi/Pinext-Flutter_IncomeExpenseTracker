import 'dart:developer';
import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/bloc/signin_cubit/signin_cubit_cubit.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/socials_button.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/routing/routes.dart';
import '../../app_data/theme_data/colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SignupScreenView();
  }
}

class SignupScreenView extends StatefulWidget {
  const SignupScreenView({Key? key}) : super(key: key);

  @override
  State<SignupScreenView> createState() => _SignupScreenViewState();
}

class _SignupScreenViewState extends State<SignupScreenView> {
  List registrationPages = [];

  late TextEditingController netBalanceController;
  late TextEditingController monthlyBudgetController;
  late TextEditingController budgetSpentSoFarController;
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    netBalanceController = TextEditingController();
    monthlyBudgetController = TextEditingController();
    budgetSpentSoFarController = TextEditingController();

    registrationPages.add(
      UserRegistrationPage(
        userNameController: userNameController,
        passwordController: passwordController,
        emailController: emailController,
      ),
    );
    registrationPages.add(
      CardsAndBalancesRegistrationPage(
        budgetSpentSoFarController: budgetSpentSoFarController,
        netBalanceController: netBalanceController,
        monthlyBudgetController: monthlyBudgetController,
        emailController: emailController,
        userNameController: userNameController,
        passwordController: passwordController,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    netBalanceController.dispose();
    monthlyBudgetController.dispose();
    budgetSpentSoFarController.dispose();
    super.dispose();
  }

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
  UserRegistrationPage(
      {Key? key,
      required this.userNameController,
      required this.emailController,
      required this.passwordController})
      : super(key: key);
  TextEditingController userNameController;
  TextEditingController emailController;
  TextEditingController passwordController;

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
              controller: userNameController,
              hintTitle: "Enter username...",
            ),
            const SizedBox(
              height: 8,
            ),
            GetCustomTextField(
              controller: emailController,
              hintTitle: "Enter email address...",
            ),
            const SizedBox(
              height: 8,
            ),
            GetCustomTextField(
              controller: passwordController,
              hintTitle: "Password",
              isPassword: true,
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
                    if (userNameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      state.pageController.animateToPage(
                        1,
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        curve: Curves.linear,
                      );
                    } else {
                      ElegantNotification.info(
                        title: Text(
                          "....",
                          style: boldTextStyle,
                        ),
                        description: Text(
                          "You need to fill up the form to proceed to the next step!",
                          style: regularTextStyle,
                        ),
                        width: getWidth(context) * .9,
                        animationDuration: const Duration(milliseconds: 200),
                        toastDuration: const Duration(seconds: 5),
                      ).show(context);
                    }
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
      ),
    );
  }
}

class CardsAndBalancesRegistrationPage extends StatelessWidget {
  CardsAndBalancesRegistrationPage({
    Key? key,
    required this.netBalanceController,
    required this.monthlyBudgetController,
    required this.budgetSpentSoFarController,
    required this.emailController,
    required this.userNameController,
    required this.passwordController,
  }) : super(key: key);

  TextEditingController userNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController netBalanceController;
  TextEditingController monthlyBudgetController;
  TextEditingController budgetSpentSoFarController;

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
                    controller: netBalanceController,
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
              "Monthly Budget",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            GetCustomTextField(
              controller: monthlyBudgetController,
              hintTitle: "Enter your monthly budget",
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "And how much of that have you spent so far?",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            GetCustomTextField(
              controller: budgetSpentSoFarController,
              hintTitle: "Budget spent so far...",
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
            BlocBuilder<SigninCubit, SigninState>(
              builder: (context, state) {
                log(state.cards.length.toString());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.cards.isEmpty
                        ? Text(
                            "Please add a card/'s to continue with the registration process!",
                            style: regularTextStyle.copyWith(
                              color: customBlackColor.withOpacity(.4),
                            ),
                          )
                        : const SizedBox.shrink(),
                    ListView.builder(
                      itemCount: state.cards.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        PinextCardModel pinextCardModel = state.cards[index];
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          pinextCardModel.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: customBlackColor,
                                          ),
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          height: .5,
                                          color:
                                              customBlackColor.withOpacity(.2),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Current balance",
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10,
                                                color: customBlackColor
                                                    .withOpacity(.4),
                                              ),
                                            ),
                                            Text(
                                              pinextCardModel.balance
                                                  .toString(),
                                              style: const TextStyle(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Last transaction",
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10,
                                              color: customBlackColor
                                                  .withOpacity(.4),
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
                                          color:
                                              customBlackColor.withOpacity(.2),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.edit,
                                                color: customBlackColor,
                                              ),
                                            ),
                                            Container(
                                              width: 55,
                                              height: .5,
                                              color: customBlackColor
                                                  .withOpacity(.2),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<SigninCubit>()
                                                    .removeCard(index);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: customBlackColor,
                                              ),
                                            )
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
                  ],
                );
              },
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
            GestureDetector(
              onTap: () {
                // context.read<SigninCubit>().addCard(PinextCardModel(
                //     title: "title",
                //     description: "description",
                //     balance: 0.00,
                //     color: "Black",
                //     lastTransactionData: DateTime.now().toString()));
                Navigator.pushNamed(context, ROUTES.getAddPinextCardRoute);
              },
              child: Container(
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
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<SigninCubit, SigninState>(
              listener: (context, state) {
                if (state is SigninErrorState) {
                  ElegantNotification.error(
                    title: Text(
                      "Snap, an error occurred!",
                      style: boldTextStyle,
                    ),
                    description: Text(
                      state.errorMessage,
                      style: regularTextStyle,
                    ),
                    width: getWidth(context) * .9,
                    animationDuration: const Duration(milliseconds: 200),
                    toastDuration: const Duration(seconds: 5),
                  ).show(context);
                  context.read<SigninCubit>().reset();
                }
                if (state is SigninSuccessState) {
                  Navigator.pop(context);
                  ElegantNotification.success(
                    title: Text(
                      "Yaay!",
                      style: boldTextStyle,
                    ),
                    description: Text(
                      "Your account has been created!",
                      style: regularTextStyle,
                    ),
                    width: getWidth(context) * .9,
                    animationDuration: const Duration(milliseconds: 200),
                    toastDuration: const Duration(seconds: 5),
                  ).show(context);
                  context.read<SigninCubit>().reset();
                }
              },
              builder: (context, state) {
                return GetCustomButton(
                  title: "Register",
                  titleColor: whiteColor,
                  buttonColor: customBlueColor,
                  isLoading: state is SigninLoadingState,
                  callBackFunction: () {
                    if (netBalanceController.text.isNotEmpty &&
                        monthlyBudgetController.text.isNotEmpty &&
                        budgetSpentSoFarController.text.isNotEmpty &&
                        state.cards.isNotEmpty) {
                      context.read<SigninCubit>().signupUser(
                            emailAddress: emailController.text,
                            password: passwordController.text,
                            username: userNameController.text,
                            pinextCards: state.cards,
                            netBalance: netBalanceController.text,
                            monthlyBudget: monthlyBudgetController.text,
                            budgetSpentSoFar: budgetSpentSoFarController.text,
                          );
                    } else {
                      ElegantNotification.info(
                        title: Text(
                          "....",
                          style: boldTextStyle,
                        ),
                        description: Text(
                          "You need to fill up the form in order to create an account!",
                          style: regularTextStyle,
                        ),
                        width: getWidth(context) * .9,
                        animationDuration: const Duration(milliseconds: 200),
                        toastDuration: const Duration(seconds: 5),
                      ).show(context);
                    }
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
                  title: "Back",
                  titleColor: whiteColor,
                  buttonColor: customBlackColor,
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
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
