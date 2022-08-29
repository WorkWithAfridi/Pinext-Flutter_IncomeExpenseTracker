import 'dart:developer';
import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/bloc/signin_cubit/signin_cubit_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
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

  late TextEditingController monthlyBudgetController;
  late TextEditingController budgetSpentSoFarController;
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  late PageController signupPageController;

  @override
  void initState() {
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    monthlyBudgetController = TextEditingController();
    budgetSpentSoFarController = TextEditingController();
    signupPageController = PageController();

    registrationPages.add(
      UserRegistrationPage(
        userNameController: userNameController,
        passwordController: passwordController,
        emailController: emailController,
        pageController: signupPageController,
      ),
    );
    registrationPages.add(
      CardsAndBalancesRegistrationPage(
        budgetSpentSoFarController: budgetSpentSoFarController,
        monthlyBudgetController: monthlyBudgetController,
        emailController: emailController,
        userNameController: userNameController,
        passwordController: passwordController,
        pageController: signupPageController,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    monthlyBudgetController.dispose();
    budgetSpentSoFarController.dispose();
    signupPageController.dispose();
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
            controller: signupPageController,
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
            GetCustomButton(
              title: "Next",
              titleColor: whiteColor,
              buttonColor: customBlueColor,
              isLoading: false,
              callBackFunction: () {
                if (userNameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  pageController.jumpToPage(
                    1,
                  );
                } else {
                  GetCustomSnackbar(
                    title: "....",
                    message:
                        "You need to fill up the form to proceed to the next step!",
                    snackbarType: SnackbarType.info,
                    context: context,
                  );
                }
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
    required this.monthlyBudgetController,
    required this.budgetSpentSoFarController,
    required this.emailController,
    required this.userNameController,
    required this.passwordController,
    required this.pageController,
  }) : super(key: key);

  TextEditingController userNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController monthlyBudgetController;
  TextEditingController budgetSpentSoFarController;
  PageController pageController;
  double netBalance = 0;

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
                  BlocBuilder<SigninCubit, SigninState>(
                    builder: (context, state) {
                      netBalance = 0;
                      for (PinextCardModel card in state.cards) {
                        netBalance += double.parse(card.balance.toString());
                      }
                      return Text(
                        netBalance.toString(),
                        style: boldTextStyle.copyWith(
                          color: customBlackColor,
                          fontSize: 50,
                        ),
                      );
                    },
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
                  Text(
                    "*Please add in cards to see your updated NET balance here!",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.3),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
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
              textInputType: TextInputType.number,
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
              textInputType: TextInputType.number,
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
                  context.read<UserBloc>().add(RefreshUserStateEvent());
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    ROUTES.getHomeframeRoute,
                    (route) => false,
                  );
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
                    if (monthlyBudgetController.text.isNotEmpty &&
                        budgetSpentSoFarController.text.isNotEmpty &&
                        state.cards.isNotEmpty) {
                      context.read<SigninCubit>().signupUser(
                            emailAddress: emailController.text,
                            password: passwordController.text,
                            username: userNameController.text,
                            pinextCards: state.cards,
                            netBalance: netBalance.floor().toString(),
                            monthlyBudget: monthlyBudgetController.text,
                            budgetSpentSoFar: budgetSpentSoFarController.text,
                          );
                    } else {
                      GetCustomSnackbar(
                        title: "....",
                        message:
                            "You need to fill up the form to create an account.",
                        snackbarType: SnackbarType.info,
                        context: context,
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            GetCustomButton(
              title: "Back",
              titleColor: whiteColor,
              buttonColor: customBlackColor,
              isLoading: false,
              callBackFunction: () {
                pageController.jumpToPage(
                  0,
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
