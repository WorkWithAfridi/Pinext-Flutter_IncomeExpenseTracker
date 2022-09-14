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
import '../../../services/date_time_services.dart';
import '../../../services/handlers/file_handler.dart';

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

  late ScrollController monthScrollController;
  @override
  void initState() {
    monthScrollController =
        ScrollController(initialScrollOffset: 30.0 * int.parse(currentMonth));
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Pinext",
                    style: regularTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.6),
                    ),
                  ),
                  Text(
                    "Archives",
                    style: boldTextStyle.copyWith(
                      fontSize: 25,
                    ),
                  ),
                  BlocBuilder<ArchiveCubit, ArchiveState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          String selectedMonth =
                              "0${int.parse(state.selectedMonth)}".length > 2
                                  ? "0${int.parse(state.selectedMonth)}"
                                      .substring(1, 3)
                                  : "0${int.parse(state.selectedMonth)}";
                          FileHandler().createReportForMonth(
                            int.parse(selectedMonth),
                            context,
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Generate report",
                              style: boldTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Icon(
                              Icons.download,
                              size: 16,
                              color: customBlueColor,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      var selectedDate = DateTime.now();
                      showDialog(
                        context: context,
                        builder: (BuildContext builderContext) {
                          return AlertDialog(
                            title: Text(
                              'Select year',
                              style: boldTextStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            content: SizedBox(
                              width: 300,
                              height: 300,
                              child: YearPicker(
                                firstDate:
                                    DateTime(DateTime.now().year - 100, 1),
                                lastDate: DateTime(DateTime.now().year, 1),
                                initialDate: DateTime.now(),
                                selectedDate: selectedDate,
                                onChanged: (DateTime dateTime) {
                                  context
                                      .read<ArchiveCubit>()
                                      .changeYear(dateTime.year.toString());
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: BlocBuilder<ArchiveCubit, ArchiveState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.selectedYear,
                              style: boldTextStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Icon(
                              Icons.edit_calendar_rounded,
                              color: customBlueColor,
                              size: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
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
        TransactionsList()
      ],
    );
  }
}

class TransactionsList extends StatelessWidget {
  TransactionsList({
    Key? key,
  }) : super(key: key);

  List<String> filters = [
    "All transactions",
    "Income",
    "Expenses",
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
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
                        .doc(state.selectedYear)
                        .collection(selectedMonth)
                        .orderBy(
                          "transactionDate",
                          descending: true,
                        )
                        .snapshots(),
                    builder: ((context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox.shrink(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 300,
                          child: Container(
                            // height: double.maxFinite,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "404",
                                  style: boldTextStyle.copyWith(
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "No data found!",
                                  style: regularTextStyle,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  ":(",
                                  style: regularTextStyle,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Wrap(
                              spacing: 5,
                              runSpacing: -8,
                              children: [
                                ...List.generate(
                                  filters.length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        String selectedFilter =
                                            filters[index].toString();
                                        if (state.selectedFilter !=
                                            selectedFilter) {
                                          context
                                              .read<ArchiveCubit>()
                                              .changeFilter(selectedFilter);
                                        } else {
                                          context
                                              .read<ArchiveCubit>()
                                              .changeFilter(
                                                "All transactions",
                                              );
                                        }
                                      },
                                      child: Chip(
                                        elevation: 0,
                                        label: Text(
                                          filters[index].toString(),
                                          style: regularTextStyle.copyWith(
                                            color: filters[index] ==
                                                    state.selectedFilter
                                                ? whiteColor
                                                : customBlackColor
                                                    .withOpacity(.6),
                                          ),
                                        ),
                                        backgroundColor: filters[index] ==
                                                state.selectedFilter
                                            ? customBlueColor
                                            : greyColor,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ],
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
                                PinextTransactionModel pinextTransactionModel =
                                    PinextTransactionModel.fromMap(
                                  snapshot.data!.docs[index].data(),
                                );
                                if (state.selectedFilter ==
                                    "All transactions") {
                                  return TransactionDetailsCard(
                                      pinextTransactionModel:
                                          pinextTransactionModel);
                                } else if (state.selectedFilter == "Income" &&
                                    pinextTransactionModel.transactionType ==
                                        "Income") {
                                  return TransactionDetailsCard(
                                      pinextTransactionModel:
                                          pinextTransactionModel);
                                } else if (state.selectedFilter == "Expenses" &&
                                    pinextTransactionModel.transactionType ==
                                        "Expense") {
                                  return TransactionDetailsCard(
                                      pinextTransactionModel:
                                          pinextTransactionModel);
                                }
                                return const SizedBox.shrink();
                              }),
                            ),
                          )
                        ],
                      );
                    }),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionDetailsCard extends StatelessWidget {
  const TransactionDetailsCard({
    Key? key,
    required this.pinextTransactionModel,
  }) : super(key: key);

  final PinextTransactionModel pinextTransactionModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Text(
              DateFormat('dd-MM-yyyy').format(
                  DateTime.parse(pinextTransactionModel.transactionDate)),
              style: regularTextStyle.copyWith(
                color: customBlackColor.withOpacity(.80),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            Expanded(
              child: Text(
                pinextTransactionModel.details,
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.80),
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
                pinextTransactionModel.transactionType == 'Expense'
                    ? "- ${pinextTransactionModel.amount}Tk"
                    : "+ ${pinextTransactionModel.amount}Tk",
                style: boldTextStyle.copyWith(
                  color: pinextTransactionModel.transactionType == 'Expense'
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
          color: customBlackColor.withOpacity(.05),
        )
      ],
    );
  }
}
