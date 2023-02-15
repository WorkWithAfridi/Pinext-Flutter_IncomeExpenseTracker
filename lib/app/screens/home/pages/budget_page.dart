import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/budget_bloc/budget_bloc.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../bloc/demoBloc/demo_bloc.dart';
import '../../../bloc/userBloc/user_bloc.dart';
import '../../../models/pinext_transaction_model.dart';
import '../../../services/date_time_services.dart';
import '../../../services/firebase_services.dart';
import '../../../shared/widgets/budget_estimations.dart';
import '../../../shared/widgets/info_widget.dart';
import '../../../shared/widgets/transaction_details_card.dart';

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
          height: 8,
        ),
        StreamBuilder(
          stream: FirebaseServices()
              .firebaseFirestore
              .collection('pinext_users')
              .doc(FirebaseServices().getUserId())
              .collection('pinext_transactions')
              .doc(currentYear)
              .collection(currentMonth)
              .orderBy(
                "transactionDate",
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
                      if (snapshot.data!.docs.isEmpty) {
                        return const Text("No data found! :(");
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Text(
                          "No data found! :(",
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.4),
                          ),
                        );
                      }

                      PinextTransactionModel pinextTransactionModel = PinextTransactionModel.fromMap(
                        snapshot.data!.docs[index].data(),
                      );
                      return TransactionDetailsCard(pinextTransactionModel: pinextTransactionModel);
                    }),
                  ),
                )
              ],
            );
          }),
        ),
      ],
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
                              final state = context.watch<UserBloc>().state;
                              final demoBlocState = context.watch<DemoBloc>().state;
                              if (state is AuthenticatedUserState) {
                                return Text(
                                  demoBlocState is DemoEnabledState ? "75000 Tk" : "${state.monthlySavings} Tk",
                                  style: boldTextStyle.copyWith(
                                    fontSize: 20,
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
