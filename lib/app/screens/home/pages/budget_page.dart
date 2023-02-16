import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/budget_bloc/budget_bloc.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/shared/widgets/budget_estimations.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../bloc/demoBloc/demo_bloc.dart';
import '../../../bloc/userBloc/user_bloc.dart';
import '../../../services/date_time_services.dart';
import '../../../services/firebase_services.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetBloc(),
      child: const BudgetView(),
    );
  }
}

class BudgetView extends StatelessWidget {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        Text(
          "Subscriptions",
          style: boldTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        InfoWidget(
          infoText:
              "Tired of adding repetitive transactions? Try adding subscriptions, which will automatically deduct (if automatically deduction is set, during set-up process) that amount from your specified card at the beginning of every month!",
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
                "lastPaidOn",
                descending: false,
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
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
                ),
              ],
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

  @override
  Widget build(BuildContext context) {
    log(subscriptionModel.lastPaidOn.substring(5, 7));
    log(currentMonth);
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              defaultBorder,
            ),
            border: Border.all(
              color: customBlackColor.withOpacity(.2),
              width: .5,
            ),
          ),
          width: getWidth(context),
          child: Builder(
            builder: (context) {
              final demoBlocState = context.watch<DemoBloc>().state;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                                      "${subscriptionModel.amount} Tk",
                                      maxLines: 1,
                                      style: boldTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Details : ",
                                  style: regularTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.7),
                                  ),
                                ),
                                TextSpan(
                                  text: subscriptionModel.description,
                                  style: boldTextStyle,
                                )
                              ],
                            ),
                          ),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Status : ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: customBlackColor.withOpacity(.4),
                              ),
                            ),
                            Text(
                              subscriptionModel.lastPaidOn.substring(5, 7) == currentMonth ? "PAID" : "DUE",
                              style: regularTextStyle.copyWith(
                                  color: subscriptionModel.lastPaidOn.substring(5, 7) == currentMonth
                                      ? customBlackColor
                                      : Colors.red[400]),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // onEditButtonClick();
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: customBlackColor,
                                ),
                              ),
                              Container(
                                width: 30,
                                height: .5,
                                color: customBlackColor.withOpacity(.2),
                              ),
                              IconButton(
                                onPressed: () {
                                  demoBlocState is DemoEnabledState ? () {} : () {};
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
              );
            },
          ),
        ));
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
                              final state = context.watch<UserBloc>().state;
                              final demoBlocState = context.watch<DemoBloc>().state;
                              if (state is AuthenticatedUserState) {
                                return Text(
                                  demoBlocState is DemoEnabledState ? "75000 Tk" : "${state.monthlySavings} Tk",
                                  style: boldTextStyle.copyWith(
                                    fontSize: 20,
                                    color: Colors.green,
                                  ),
                                );
                              }
                              return Text(
                                "Loading...",
                                style: boldTextStyle.copyWith(
                                  fontSize: 20,
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
                              final state = context.watch<UserBloc>().state;
                              final demoBlocState = context.watch<DemoBloc>().state;
                              if (state is AuthenticatedUserState) {
                                return Text(
                                  demoBlocState is DemoEnabledState
                                      ? "100000 Tk"
                                      : "${state.monthlyEarnings == "" ? "0000" : state.monthlyEarnings} Tk",
                                  style: boldTextStyle.copyWith(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                );
                              }
                              return Text(
                                "Loading...",
                                style: boldTextStyle.copyWith(
                                  fontSize: 20,
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
