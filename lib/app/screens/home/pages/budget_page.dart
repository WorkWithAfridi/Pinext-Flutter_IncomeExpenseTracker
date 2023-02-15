import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../models/pinext_transaction_model.dart';
import '../../../services/date_time_services.dart';
import '../../../services/firebase_services.dart';
import '../../../shared/widgets/budget_estimations.dart';
import '../../../shared/widgets/transaction_details_card.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
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
                Text(
                  "Subscriptions",
                  style: boldTextStyle.copyWith(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoWidget(
                  infoText:
                      "Adding subscriptions will automatically deduct (if automatically deduction is set, during set-up process) that amount from your specified card at the beginning of every month!",
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
