import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/signup_cubit/signin_cubit_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/add_and_edit_pinext_card/add_and_edit_pinext_card.dart';
import 'package:pinext/app/screens/goals_and_milestones/add_and_edit_goal_and_milestone_screen.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';
import 'package:pinext/app/shared/widgets/pinext_card_minimized.dart';
import 'package:pinext/app/shared/widgets/pinext_goal_minimized.dart';

class CardsAndBalancesRegistrationPage extends StatelessWidget {
  CardsAndBalancesRegistrationPage({
    required this.monthlyBudgetController, required this.budgetSpentSoFarController, required this.emailController, required this.userNameController, required this.passwordController, required this.pageController, super.key,
  });

  TextEditingController userNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController monthlyBudgetController;
  TextEditingController budgetSpentSoFarController;
  PageController pageController;
  double netBalance = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pinext',
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
              Text(
                'Cards and Balances',
                style: boldTextStyle.copyWith(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Stack(
                children: [
                  Container(
                    height: 200,
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
                      children: [
                        Text(
                          'Your NET. Balance is',
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
                            for (final card in state.cards) {
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
                        BlocBuilder<RegionCubit, RegionState>(
                          builder: (context, state) {
                            return Text(
                              state.countryData.currency,
                              style: boldTextStyle.copyWith(
                                color: customBlackColor.withOpacity(.6),
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: defaultPadding,
                    right: defaultPadding,
                    child: InfoWidget(
                      infoText: 'Please add PINEXT cards to see your updated NET balance!',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monthly Budget',
                    style: boldTextStyle,
                  ),
                  InfoWidget(
                    infoText: "This is the maximum amount of CASH you'll be spending in one month!",
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              CustomTextFormField(
                controller: monthlyBudgetController,
                hintTitle: 'Enter your monthly budget',
                textInputType: TextInputType.number,
                onChanged: (String value) {},
                validator: (String value) {
                  return InputValidation(value).isCorrectNumber();
                },
                suffixButtonAction: () {},
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'And how much of that have you spent so far?',
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextFormField(
                controller: budgetSpentSoFarController,
                hintTitle: 'Budget spent so far...',
                textInputType: TextInputType.number,
                onChanged: (String value) {},
                validator: (String value) {
                  return InputValidation(value).isCorrectNumber();
                },
                suffixButtonAction: () {},
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Manage Cards',
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
                      if (state.cards.isEmpty)
                        Text(
                          "Please add a card/'s to continue with the registration process!",
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.4),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      MediaQuery.removePadding(
                        context: context,
                        removeBottom: true,
                        child: ListView.builder(
                          itemCount: state.cards.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final pinextCardModel = state.cards[index];
                            return PinextCardMinimized(
                              onDeleteButtonClick: () {
                                context.read<SigninCubit>().removeCard(index);
                              },
                              onEditButtonClick: () {
                                //TODO: Add logic
                              },
                              pinextCardModel: pinextCardModel,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add a new card',
                    style: boldTextStyle,
                  ),
                  InfoWidget(
                    infoText: 'You will be using these cards to keep a track on your money sources, be either income or expenses.',
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CustomTransitionPageRoute(
                      childWidget: AddAndEditPinextCardScreen(
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
                        'Add a new card',
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
              Text(
                'Manage Goals',
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
                      if (state.goals.isEmpty)
                        Text(
                          'Add goals and milestones to view them here! You dont necessarily need them, for the registration process.',
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.4),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      MediaQuery.removePadding(
                        context: context,
                        removeBottom: true,
                        child: ListView.builder(
                          itemCount: state.goals.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final pinextGoalModel = state.goals[index];
                            return PinextGoalCardMinimized(
                              pinextGoalModel: pinextGoalModel,
                              index: index,
                              showCompletePercentage: false,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add goals/ milestones',
                    style: boldTextStyle,
                  ),
                  InfoWidget(
                    infoText:
                        'These will be your goals and milestones for the coming months, years and so on. Once you save up to them, your goals will be archived and you can add new goals.',
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CustomTransitionPageRoute(
                      childWidget: AddAndEditGoalsAndMilestoneScreen(
                        addingNewGoal: false,
                        addingNewGoalDuringSignupProcess: true,
                        editingGoal: false,
                        pinextGoalModel: null,
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
                        'Add a goal/ milestone',
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
                      showToast(
                        title: 'Snap, an error occurred!',
                        message: state.errorMessage,
                        snackbarType: SnackbarType.success,
                        context: context,
                      );
                      context.read<SigninCubit>().reset();
                    }
                    if (state is SigninSuccessState) {
                      context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
                      context.read<SigninCubit>().reset();
                    }
                  },
                  builder: (context, state) {
                    return GetCustomButton(
                      title: 'Register',
                      titleColor: whiteColor,
                      buttonColor: primaryColor,
                      isLoading: state is SigninLoadingState,
                      callBackFunction: () {
                        if (_formKey.currentState!.validate()) {
                          if (monthlyBudgetController.text.isNotEmpty && budgetSpentSoFarController.text.isNotEmpty
                              // &&  state.cards.isNotEmpty
                              ) {
                            context.read<SigninCubit>().signupUser(
                                  emailAddress: emailController.text,
                                  password: passwordController.text,
                                  username: userNameController.text,
                                  pinextCards: state.cards,
                                  netBalance: netBalance.floor().toString(),
                                  monthlyBudget: monthlyBudgetController.text,
                                  budgetSpentSoFar: budgetSpentSoFarController.text,
                                  pinextGoals: state.goals,
                                  regionCode: context.read<RegionCubit>().state.countryData.code,
                                );
                          } else {
                            showToast(
                              title: '....',
                              message: 'You need to fill up the form to create an account.',
                              snackbarType: SnackbarType.info,
                              context: context,
                            );
                          }
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
                title: 'Back',
                titleColor: whiteColor,
                buttonColor: customBlackColor,
                callBackFunction: () {
                  pageController.jumpToPage(
                    0,
                  );
                },
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
