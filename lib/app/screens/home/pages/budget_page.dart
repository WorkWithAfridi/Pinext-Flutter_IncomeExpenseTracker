import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/archive_cubit/user_statistics_cubit/user_statistics_cubit.dart';
import 'package:pinext/app/bloc/budget_cubit/budget_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/update_subscription_cubit/update_subscription_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/screens/home/pages/budget_pages/add_subscription_page.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/budget_estimations.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/horizontal_bar.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BudgetCubit(),
        ),
        BlocProvider(
          create: (context) => UpdateSubscriptionCubit(),
        ),
      ],
      child: const BudgetView(),
    );
  }
}

class BudgetView extends StatelessWidget {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateSubscriptionCubit, UpdateSubscriptionState>(
          listener: (context, state) {
            if (state is SubscriptionUpdatedSuccessfullyState) {
              context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
            } else if (state is SubscriptionUpdatedErrorState) {
              showToast(
                title: 'Snap',
                message: state.errorMessage,
                snackbarType: SnackbarType.error,
                context: context,
              );
            }

            context.read<UpdateSubscriptionCubit>().resetState();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SizedBox(
          height: getHeight(context),
          width: getWidth(context),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Animate(
                        effects: const [
                          SlideEffect(),
                          FadeEffect(),
                        ],
                        child: Text(
                          'Budget & Subscriptions',
                          style: cursiveTextStyle.copyWith(
                            fontSize: 30,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GetBudgetEstimationsWidget(),
                      const SizedBox(
                        height: 12,
                      ),
                      const _GetStatisticsWidget(),
                      const _GetSubscriptionDetailsWidget(),
                      const SizedBox(
                        height: 12,
                      ),
                      const _GetSubscriptionWidget(),
                      const SizedBox(
                        height: kToolbarHeight * 2,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: defaultPadding,
                right: defaultPadding,
                child: FloatingActionButton(
                  elevation: 6,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CustomTransitionPageRoute(
                        childWidget: AddSubscriptionPage(),
                      ),
                    );
                  },
                  backgroundColor: darkPurpleColor,
                  child: const Icon(
                    Icons.add,
                    color: whiteColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GetStatisticsWidget extends StatelessWidget {
  const _GetStatisticsWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatisticsCubit, UserStatisticsState>(
      builder: (context, state) {
        final demoBlocState = context.watch<DemoBloc>().state;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Overview',
                  style: boldTextStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const GetHorizontalBar(),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Column(
              children: [
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Income',
                  amount: state.income.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Food and Groceries',
                  amount: state.foodAndGroceries.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Transportation',
                  amount: state.transportation.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Housing and Utilities',
                  amount: state.housingAndUtilities.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Health and Wellness',
                  amount: state.healthAndWellness.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Education and Training',
                  amount: state.educationAndTraining.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Entertainment and Leisure',
                  amount: state.entertainmentAndLeisure.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Personal Care',
                  amount: state.personalCare.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Clothing and Accessories',
                  amount: state.clothingAndAccessories.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Gifts and Donations',
                  amount: state.giftsAndDonations.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Miscellaneous',
                  amount: state.miscellaneous.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Others',
                  amount: state.others.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Transferred',
                  amount: state.transfer.toString(),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  width: getWidth(context),
                  color: customBlackColor.withOpacity(.05),
                ),
                const SizedBox(
                  height: 4,
                ),
                _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Subscriptions',
                  amount: state.subscription.toString(),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  'Summary',
                  style: boldTextStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const GetHorizontalBar(),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Builder(
              builder: (context) {
                final demoBlocState = context.watch<DemoBloc>().state;
                return _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Withdrawals',
                  amount: state.totalExpenses.toString(),
                );
              },
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              height: 1,
              width: getWidth(context),
              color: customBlackColor.withOpacity(.05),
            ),
            const SizedBox(
              height: 4,
            ),
            Builder(
              builder: (context) {
                final demoBlocState = context.watch<DemoBloc>().state;
                return _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Diposits',
                  amount: state.totalSavings.toString(),
                );
              },
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              height: 1,
              width: getWidth(context),
              color: customBlackColor.withOpacity(.05),
            ),
            const SizedBox(
              height: 4,
            ),
            Builder(
              builder: (context) {
                final state = context.watch<UserBloc>().state;
                final demoBlocState = context.watch<DemoBloc>().state;

                var totalEarnings = '';
                if (state is AuthenticatedUserState) {
                  totalEarnings = state.monthlyEarnings;
                }
                return _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: "You've earned",
                  amount: totalEarnings,
                );
              },
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              height: 1,
              width: getWidth(context),
              color: customBlackColor.withOpacity(.05),
            ),
            const SizedBox(
              height: 4,
            ),
            Builder(
              builder: (context) {
                final state = context.watch<UserBloc>().state;
                final demoBlocState = context.watch<DemoBloc>().state;

                var totalSavings = '';
                if (state is AuthenticatedUserState) {
                  totalSavings = state.monthlySavings;
                }
                return _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: "You've saved",
                  amount: totalSavings,
                );
              },
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              height: 1,
              width: getWidth(context),
              color: customBlackColor.withOpacity(.05),
            ),
            const SizedBox(
              height: 4,
            ),
            Builder(
              builder: (context) {
                final state = context.watch<UserBloc>().state;
                final demoBlocState = context.watch<DemoBloc>().state;
                var netWorth = '';
                if (state is AuthenticatedUserState) {
                  netWorth = state.netBalance;
                }
                return _GetOverviewWidget(
                  isDemoActive: demoBlocState is DemoEnabledState,
                  title: 'Current NET. balance',
                  amount: netWorth,
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        );
      },
    );
  }
}

class _GetOverviewWidget extends StatelessWidget {
  _GetOverviewWidget({
    required this.isDemoActive,
    required this.title,
    required this.amount,
  });

  String amount;
  bool isDemoActive;
  String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title: ',
          style: regularTextStyle.copyWith(
            color: customBlackColor.withOpacity(.80),
          ),
        ),
        BlocBuilder<RegionCubit, RegionState>(
          builder: (context, state) {
            return Text(
              isDemoActive ? '100000 ${state.countryData.symbol}' : ' $amount ${state.countryData.symbol}',
              style: boldTextStyle.copyWith(
                color: primaryColor,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _GetSubscriptionWidget extends StatelessWidget {
  const _GetSubscriptionWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly subscriptions',
              style: boldTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const GetHorizontalBar(),
            const SizedBox(
              width: 8,
            ),
            InfoWidget(
              infoText:
                  'Tired of adding repetitive transactions? Try adding subscriptions, subscriptions will automatically deduct (if automatically deduction is set, during set-up process) that amount from your specified card at the beginning of every month!',
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder(
          stream: FirebaseServices()
              .firebaseFirestore
              .collection('pinext_users')
              .doc(FirebaseServices().getUserId())
              .collection('pinext_subscriptions')
              .orderBy(
                'dateAdded',
                descending: true,
              )
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox.shrink(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Text(
                'You dont have any active subscriptions at the moment! Please add subscriptions to view them here!',
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              );
            }
            context.read<BudgetCubit>().resetSubscriptionDetailCount();
            return ListView.builder(
              itemCount: snapshot.data!.docs.length > 10 ? 10 : snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final subscriptionModel = PinextSubscriptionModel.fromMap(
                  snapshot.data!.docs[index].data(),
                );
                return SubscriptionCard(subscriptionModel: subscriptionModel);
              },
            );
          },
        ),
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  SubscriptionCard({
    required this.subscriptionModel,
    super.key,
  });

  late int date;
  PinextSubscriptionModel subscriptionModel;

  @override
  Widget build(BuildContext context) {
    if (subscriptionModel.lastPaidOn.substring(5, 7) == currentMonth) {
      context.read<BudgetCubit>().updatePaidAmount(double.parse(subscriptionModel.amount));
    } else {
      context.read<BudgetCubit>().updateDueAmount(double.parse(subscriptionModel.amount));
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CustomTransitionPageRoute(
              childWidget: AddSubscriptionPage(
                isEdit: true,
                subscriptionModel: subscriptionModel,
              ),
            ),
          );
        },
        child: Container(
          height: kToolbarHeight,
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.circular(
              defaultBorder,
            ),
          ),
          padding: const EdgeInsets.only(left: defaultPadding, right: 4),
          child: Builder(
            builder: (context) {
              final demoBlocState = context.watch<DemoBloc>().state;
              final regionState = context.watch<RegionCubit>().state;
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demoBlocState is DemoEnabledState ? 'Subscription name'.capitalize() : subscriptionModel.title.capitalize(),
                          style: boldTextStyle.copyWith(
                            fontSize: 18,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Amount : ',
                              style: regularTextStyle.copyWith(
                                color: customBlackColor.withOpacity(.7),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                demoBlocState is DemoEnabledState
                                    ? '1000 ${regionState.countryData.symbol}'
                                    : '${subscriptionModel.amount} ${regionState.countryData.symbol}',
                                maxLines: 1,
                                style: regularTextStyle.copyWith(
                                  color: customBlackColor.withOpacity(.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (subscriptionModel.lastPaidOn.substring(5, 7) == currentMonth)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: defaultPadding - 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'STATUS: ',
                            style: boldTextStyle.copyWith(
                              color: darkPurpleColor,
                            ),
                          ),
                          Text(
                            'PAID',
                            style: boldTextStyle.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          4,
                        ),
                      ),
                      activeColor: primaryColor,
                      value: subscriptionModel.lastPaidOn.substring(5, 7) == currentMonth,
                      onChanged: (value) async {
                        if (value == true) {
                          await context.read<UpdateSubscriptionCubit>().updateSubscriptionStatus(
                                subscriptionModel: subscriptionModel,
                                context: context,
                              );
                        } else {
                          showToast(
                            title: 'Snap',
                            message: 'This subscription has already been processed and added into PINEXT archive!',
                            snackbarType: SnackbarType.info,
                            context: context,
                          );
                        }
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GetSubscriptionDetailsWidget extends StatelessWidget {
  const _GetSubscriptionDetailsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Subscription details',
              style: boldTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const GetHorizontalBar(),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(
            defaultPadding,
          ),
          width: getWidth(context),
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.circular(
              defaultBorder,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Container(
                      color: Colors.transparent,
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          Text(
                            'Paid',
                            style: regularTextStyle.copyWith(
                              color: customBlackColor.withOpacity(.6),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Builder(
                            builder: (context) {
                              final state = context.watch<BudgetCubit>().state;
                              final demoBlocState = context.watch<DemoBloc>().state;
                              final regionState = context.watch<RegionCubit>().state;
                              return Text(
                                demoBlocState is DemoEnabledState
                                    ? '75000 ${regionState.countryData.symbol}'
                                    : '${state.paidAmount} ${regionState.countryData.symbol}',
                                style: boldTextStyle.copyWith(
                                  fontSize: 20,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                          // const SizedBox(
                          //   height: 4,
                          // ),
                          // Text(
                          //   "in ${months[int.parse(currentMonth) - 1]}.",
                          //   style: regularTextStyle.copyWith(
                          //     color: customBlackColor.withOpacity(.6),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    color: customBlackColor,
                    width: 0.2,
                  ),
                  Flexible(
                    child: Container(
                      color: Colors.transparent,
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          Text(
                            'Due',
                            style: regularTextStyle.copyWith(
                              color: customBlackColor.withOpacity(.6),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Builder(
                            builder: (context) {
                              final state = context.watch<BudgetCubit>().state;
                              final demoBlocState = context.watch<DemoBloc>().state;
                              final regionState = context.watch<RegionCubit>().state;
                              return Text(
                                demoBlocState is DemoEnabledState
                                    ? '100000 ${regionState.countryData.symbol}'
                                    : '${state.dueAmount} ${regionState.countryData.symbol}',
                                style: boldTextStyle.copyWith(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
