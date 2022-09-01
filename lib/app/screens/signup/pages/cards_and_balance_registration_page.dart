import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/screens/add_and_edit_pinext_card/add_and_edit_pinext_card.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/pinext_card_minimized.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../app_data/routing/routes.dart';
import '../../../app_data/theme_data/colors.dart';
import '../../../bloc/signup_cubit/signin_cubit_cubit.dart';
import '../../../bloc/userBloc/user_bloc.dart';
import '../../../models/pinext_card_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

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
                  const SizedBox(
                    height: 4,
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
              height: 4,
            ),
            Text(
              "*This is the maximum amount of CASH you'll be spending in one month!",
              style: regularTextStyle.copyWith(
                color: customBlackColor.withOpacity(.4),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            GetCustomTextField(
              controller: monthlyBudgetController,
              hintTitle: "Enter your monthly budget",
              textInputType: TextInputType.number,
              onChanged: () {},
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
              onChanged: () {},
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
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      child: ListView.builder(
                        itemCount: state.cards.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) {
                          log('creating list');
                          PinextCardModel pinextCardModel = state.cards[index];
                          return PinextCardMinimized(
                            onDeleteButtonClick: () {
                              log('button pressed');
                              context.read<SigninCubit>().removeCard(index);
                            },
                            onEditButtonClick: () {
                              //TODO: Add logic
                            },
                            pinextCardModel: pinextCardModel,
                          );
                        }),
                      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAndEditPinextCardScreen(
                      addCardForSignUpProcess: true,
                    ),
                  ),
                );
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
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is AuthenticatedUserState) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    ROUTES.getHomeframeRoute,
                    (route) => false,
                  );
                }
              },
              child: BlocConsumer<SigninCubit, SigninState>(
                listener: (context, state) {
                  if (state is SigninErrorState) {
                    GetCustomSnackbar(
                      title: "Snap, an error occurred!",
                      message: state.errorMessage,
                      snackbarType: SnackbarType.success,
                      context: context,
                    );
                    context.read<SigninCubit>().reset();
                  }
                  if (state is SigninSuccessState) {
                    context.read<UserBloc>().add(RefreshUserStateEvent());
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
