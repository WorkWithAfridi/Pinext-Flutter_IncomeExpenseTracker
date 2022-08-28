import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/services/firebase_services.dart';

import '../../../app_data/app_constants/fonts.dart';
import '../../../bloc/archive_cubit/archive_cubit.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchiveCubit(),
      child: const ArchiveMonthView(),
    );
  }
}

class ArchiveMonthView extends StatefulWidget {
  const ArchiveMonthView({Key? key}) : super(key: key);

  @override
  State<ArchiveMonthView> createState() => _ArchiveMonthViewState();
}

class _ArchiveMonthViewState extends State<ArchiveMonthView> {
  String dateTimeNow = DateTime.now().toString();

  String year = DateTime.now().toString().substring(0, 4);

  String month = DateTime.now().toString().substring(5, 7);

  String date = DateTime.now().toString().substring(8, 10);

  late ScrollController monthScrollController;
  @override
  void initState() {
    monthScrollController =
        ScrollController(initialScrollOffset: 26.0 * int.parse(month));
    super.initState();
  }

  @override
  void dispose() {
    monthScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Archives",
                    style: boldTextStyle.copyWith(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    year,
                    style: boldTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        Material(
          elevation: 4,
          child: Container(
            color: whiteColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: monthScrollController,
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<ArchiveCubit, ArchiveState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      ...List.generate(months.length, (index) {
                        String currentMonth = months[index];
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<ArchiveCubit>()
                                .changeMonth((index).toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 20,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              currentMonth,
                              style: regularTextStyle.copyWith(
                                fontWeight: state.selectedMonth.toString() ==
                                        (index).toString()
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: state.selectedMonth.toString() ==
                                        (index).toString()
                                    ? customBlackColor
                                    : customBlackColor.withOpacity(.4),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<ArchiveCubit, ArchiveState>(
                    builder: (context, state) {
                      String selectedMonth =
                          "0${int.parse(state.selectedMonth) + 1}".length > 2
                              ? "0${int.parse(state.selectedMonth) + 1}"
                                  .substring(1, 3)
                              : "0${int.parse(state.selectedMonth) + 1}";
                      return StreamBuilder(
                        stream: FirebaseServices()
                            .firebaseFirestore
                            .collection('pinext_users')
                            .doc(FirebaseServices().getUserId())
                            .collection('pinext_transactions')
                            .doc(year)
                            .collection(selectedMonth)
                            .orderBy("transactionDate")
                            .snapshots(),
                        builder: ((context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Showing results for",
                                  style: regularTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.4),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${months[int.parse(state.selectedMonth)]}",
                                  style: boldTextStyle.copyWith(
                                    fontSize: 25,
                                    color: customBlackColor,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "No data found! :(",
                                  style: regularTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.4),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Showing results for",
                                style: regularTextStyle.copyWith(
                                  color: customBlackColor.withOpacity(.4),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${months[int.parse(state.selectedMonth)]}",
                                style: boldTextStyle.copyWith(
                                  fontSize: 25,
                                  color: customBlackColor,
                                  height: 1.1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: ((context, index) {
                                    if (snapshot.data!.docs.isEmpty) {
                                      return const Text("No data found! :(");
                                    }

                                    PinextTransactionModel
                                        pinextTransactionModel =
                                        PinextTransactionModel.fromMap(
                                      snapshot.data!.docs[index].data(),
                                    );
                                    return Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat('dd-MM-yyyy').format(
                                                  DateTime.parse(
                                                      pinextTransactionModel
                                                          .transactionDate)),
                                              style: regularTextStyle.copyWith(
                                                color: customBlackColor
                                                    .withOpacity(.80),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 32,
                                            ),
                                            Expanded(
                                              child: Text(
                                                pinextTransactionModel.details,
                                                style:
                                                    regularTextStyle.copyWith(
                                                  color: customBlackColor
                                                      .withOpacity(.80),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              width: 100,
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                pinextTransactionModel
                                                            .transactionType ==
                                                        'Expense'
                                                    ? "- ${pinextTransactionModel.amount}Tk"
                                                    : "+ ${pinextTransactionModel.amount}Tk",
                                                style: boldTextStyle.copyWith(
                                                  color: pinextTransactionModel
                                                              .transactionType ==
                                                          'Expense'
                                                      ? Colors.red
                                                      : Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          height: 1,
                                          width: getWidth(context),
                                          color:
                                              customBlackColor.withOpacity(.05),
                                        )
                                      ],
                                    );
                                  }),
                                ),
                              )
                            ],
                          );
                        }),
                      );
                    },
                  ),
                  // ListView.builder(
                  //   itemCount: months.length,
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemBuilder: ((context, index) {
                  //     return Container(
                  //       padding: const EdgeInsets.only(bottom: 16),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "${index + 1}. ${months[index]}",
                  //             style: boldTextStyle.copyWith(
                  //               fontSize: 25,
                  //             ),
                  //           ),
                  //           ListView.builder(
                  //             itemCount: 6,
                  //             shrinkWrap: true,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             itemBuilder: ((context, index) {
                  //               return Column(
                  //                 children: [
                  //                   const SizedBox(
                  //                     height: 8,
                  //                   ),
                  //                   Row(
                  //                     children: [
                  //                       Text(
                  //                         "12/12/12",
                  //                         style: regularTextStyle.copyWith(
                  //                           color: customBlackColor
                  //                               .withOpacity(.80),
                  //                         ),
                  //                       ),
                  //                       const SizedBox(
                  //                         width: 32,
                  //                       ),
                  //                       Expanded(
                  //                         child: Text(
                  //                           "Bought something off Ryans Shantinager Branch",
                  //                           style: regularTextStyle.copyWith(
                  //                             color: customBlackColor
                  //                                 .withOpacity(.80),
                  //                           ),
                  //                           maxLines: 2,
                  //                           overflow: TextOverflow.ellipsis,
                  //                         ),
                  //                       ),
                  //                       const SizedBox(
                  //                         width: 8,
                  //                       ),
                  //                       Container(
                  //                         width: 100,
                  //                         alignment: Alignment.centerRight,
                  //                         child: Text(
                  //                           "- 120000Tk",
                  //                           style: boldTextStyle.copyWith(
                  //                             color: customBlackColor
                  //                                 .withOpacity(.80),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 8,
                  //                   ),
                  //                   Container(
                  //                     height: 1,
                  //                     width: getWidth(context),
                  //                     color: customBlackColor.withOpacity(.05),
                  //                   )
                  //                 ],
                  //               );
                  //             }),
                  //           )
                  //         ],
                  //       ),
                  //     );
                  //   }),
                  // ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
