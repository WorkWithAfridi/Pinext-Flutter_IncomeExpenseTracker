import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/budget_cubit/budget_cubit.dart';
import 'package:pinext/app/bloc/update_subscription_cubit/update_subscription_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/screens/home/pages/budget_pages/add_subscription_page.dart';
import 'package:pinext/app/shared/widgets/budget_estimations.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../bloc/demoBloc/demo_bloc.dart';
import '../../../services/date_time_services.dart';
import '../../../services/firebase_services.dart';

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
              log("Updating user state");
              context.read<UserBloc>().add(RefreshUserStateEvent());
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget & Subscriptions",
                    style: boldTextStyle.copyWith(
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const GetBudgetEstimationsWidget(),
                  const SizedBox(
                    height: 12,
                  ),
                  const _GetSubscriptionDetailsWidget(),
                  const SizedBox(
                    height: 12,
                  ),
                  const _GetSubscriptionWidget(),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GetSubscriptionWidget extends StatelessWidget {
  const _GetSubscriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Monthly subscriptions",
              style: boldTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
            InfoWidget(
              infoText:
                  "Tired of adding repetitive transactions? Try adding subscriptions, subscriptions will automatically deduct (if automatically deduction is set, during set-up process) that amount from your specified card at the beginning of every month!",
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
                "dateAdded",
                descending: true,
              )
              .snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox.shrink(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Text(
                "You dont have any active subscriptions at the moment! Please add subscriptions to view them here!",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              );
            }
            context.read<BudgetCubit>().resetSubscriptionDetailCount();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length > 10 ? 10 : snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  PinextSubscriptionModel subscriptionModel = PinextSubscriptionModel.fromMap(
                    snapshot.data!.docs[index].data(),
                  );
                  return SubscriptionCard(subscriptionModel: subscriptionModel);
                }),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  SubscriptionCard({
    Key? key,
    required this.subscriptionModel,
  }) : super(key: key);

  PinextSubscriptionModel subscriptionModel;
  late int date;

  @override
  Widget build(BuildContext context) {
    if (subscriptionModel.lastPaidOn.substring(5, 7) == currentMonth) {
      context.read<BudgetCubit>().updatePaidAmount(double.parse(subscriptionModel.amount));
    } else {
      context.read<BudgetCubit>().updateDueAmount(double.parse(subscriptionModel.amount));
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
            borderRadius: BorderRadius.circular(
              defaultBorder,
            ),
            border: Border.all(
              color: customBlackColor.withOpacity(.2),
              width: .5,
            ),
          ),
          padding: const EdgeInsets.only(left: defaultPadding, right: 4),
          child: Builder(
            builder: (context) {
              final demoBlocState = context.watch<DemoBloc>().state;
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demoBlocState is DemoEnabledState ? "Subscription name" : subscriptionModel.title,
                          style: boldTextStyle,
                          maxLines: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Amount : ",
                              style: regularTextStyle.copyWith(
                                color: customBlackColor.withOpacity(.7),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                demoBlocState is DemoEnabledState ? "1000 Tk" : "${subscriptionModel.amount} Tk",
                                maxLines: 1,
                                style: boldTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  subscriptionModel.lastPaidOn.substring(5, 7) == currentMonth
                      ? Padding(
                          padding: const EdgeInsets.only(
                            right: defaultPadding - 4,
                          ),
                          child: Text(
                            "PAID",
                            style: boldTextStyle.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        )
                      : Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              4,
                            ),
                          ),
                          activeColor: customBlueColor,
                          value: subscriptionModel.lastPaidOn.substring(5, 7) == currentMonth,
                          onChanged: (value) async {
                            if (value == true) {
                              context
                                  .read<UpdateSubscriptionCubit>()
                                  .updateSubscriptionStatus(subscriptionModel: subscriptionModel);
                            } else {
                              GetCustomSnackbar(
                                title: "Snap",
                                message: "This subscription has already been processed and added into PINEXT archive!",
                                snackbarType: SnackbarType.info,
                                context: context,
                              );
                            }
                          },
                        )
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
  const _GetSubscriptionDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Subscription details",
          style: boldTextStyle.copyWith(
            fontSize: 20,
          ),
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
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Paid",
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
                              return Text(
                                demoBlocState is DemoEnabledState ? "75000 Tk" : "${state.paidAmount} Tk",
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
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Due",
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
                              return Text(
                                demoBlocState is DemoEnabledState ? "100000 Tk" : "${state.dueAmount} Tk",
                                style: boldTextStyle.copyWith(
                                  fontSize: 20,
                                  color: Colors.red,
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
