import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/services/firebase_services.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/theme_data/colors.dart';
import '../../../bloc/homepage_cubit/homepage_cubit.dart';
import '../../../bloc/userBloc/user_bloc.dart';
import '../../../models/pinext_transaction_model.dart';
import '../../../shared/widgets/pinext_card.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomepageCubit(),
        ),
      ],
      child: HomepageView(),
    );
  }
}

class HomepageView extends StatelessWidget {
  HomepageView({
    Key? key,
  }) : super(key: key);

  final List homepageFilters = [
    'Overview',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly'
  ];

  Map<String, double> demoData = {
    "Office fare": 50,
    "Lunch": 150,
    "Snacks": 100,
    "Hangout": 80,
  };

  String year = DateTime.now().toString().substring(0, 4);

  String month = DateTime.now().toString().substring(5, 7);

  String date = DateTime.now().toString().substring(8, 10);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getHeight(context),
      width: getWidth(context),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
                    "Good morning,",
                    style: regularTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.6),
                    ),
                  ),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is AuthenticatedUserState) {
                        return Text(
                          state.username,
                          style: boldTextStyle.copyWith(
                            fontSize: 25,
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    BlocBuilder<HomepageCubit, HomepageState>(
                      builder: (context, state) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: homepageFilters.length,
                          itemBuilder: ((context, index) {
                            return MenuFilterPill(
                              filtertitle: homepageFilters[index],
                              selectedFilter: state.selectedFilter,
                            );
                          }),
                        );
                      },
                    ),
                    const SizedBox(
                      width: defaultPadding - 10,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Your Cards",
                    style: boldTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 185,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    StreamBuilder(
                      stream: FirebaseServices()
                          .firebaseFirestore
                          .collection("pinext_users")
                          .doc(FirebaseServices().getUserId())
                          .collection("pinext_cards")
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
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            PinextCardModel pinextCardModel =
                                PinextCardModel.fromMap(
                              snapshot.data!.docs[index].data(),
                            );

                            String color = pinextCardModel.color;
                            late Color cardColor = getColorFromString(color);

                            return PinextCard(
                              title: pinextCardModel.title,
                              balance: pinextCardModel.balance,
                              cardColor: cardColor,
                            );
                          }),
                        );
                      }),
                    ),
                    const SizedBox(
                      width: defaultPadding - 10,
                    ),
                  ],
                ),
              ),
            ),
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
                    "Budget Estimations",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your budget for August",
                              style: regularTextStyle,
                            ),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is AuthenticatedUserState) {
                                  return Text(
                                    "${state.monthlyBudget} Tk",
                                    style: regularTextStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Container(
                              height: 5,
                              width: getWidth(context),
                              color: customBlueColor.withOpacity(.2),
                            ),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is AuthenticatedUserState) {
                                  return LayoutBuilder(
                                    builder: ((context, constraints) {
                                      return Container(
                                        height: 5,
                                        width: constraints.maxWidth *
                                            (double.parse(
                                                    state.monthlyExpenses) /
                                                double.parse(
                                                    state.monthlyBudget)),
                                        color: customBlueColor,
                                      );
                                    }),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is AuthenticatedUserState) {
                              return RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Your have spent ",
                                      style: regularTextStyle.copyWith(
                                        color: customBlackColor.withOpacity(.6),
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "${((double.parse(state.monthlyExpenses) / double.parse(state.monthlyBudget)) * 100).ceil()}%",
                                      style: boldTextStyle.copyWith(
                                        color: Colors.red.withOpacity(.9),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " of your budget!",
                                      style: regularTextStyle.copyWith(
                                        color: customBlackColor.withOpacity(.6),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              Text(
                                "Your have spent ${((double.parse(state.monthlyExpenses) / double.parse(state.monthlyBudget)) * 100).ceil()}% of your budget!",
                                style: regularTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.6)),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Expenses",
                    style: boldTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is AuthenticatedUserState) {
                        return Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(
                                  defaultPadding,
                                ),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    defaultBorder,
                                  ),
                                  color: customBlackColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "- ${state.dailyExpenses}",
                                        style: boldTextStyle.copyWith(
                                          fontSize: 25,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Today",
                                      style: boldTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: whiteColor.withOpacity(.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.all(
                                  defaultPadding,
                                ),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    defaultBorder,
                                  ),
                                  color: customBlueColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "- ${state.weeklyExpenses}",
                                        style: boldTextStyle.copyWith(
                                          fontSize: 25,
                                          color: whiteColor.withOpacity(.8),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "This week",
                                      style: boldTextStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's overview",
                          style: boldTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: customBlackColor.withOpacity(.4),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        PieChart(
                          dataMap: demoData,
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 2,
                          colorList: const [
                            cyanColor,
                            customBlackColor,
                            customBlueColor,
                          ],
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 40,
                          centerText: "Today",
                          legendOptions: const LegendOptions(
                            showLegends: false,
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                      color: cyanColor,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Snacks",
                                        style: boldTextStyle.copyWith(
                                          fontSize: 14,
                                          color:
                                              customBlackColor.withOpacity(.8),
                                        ),
                                      ),
                                      Text(
                                        "Amount: 100Tk",
                                        style: regularTextStyle.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color:
                                              customBlackColor.withOpacity(.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  Text(
                    "Savings",
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "You have saved",
                          style: regularTextStyle,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            log("rebuilding at you have saved...");
                            if (state is AuthenticatedUserState) {
                              return Text(
                                "${state.monthlySavings} Tk",
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
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "in August alone!!",
                          style: regularTextStyle.copyWith(
                            color: customBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Latest transactions made in ${months[int.parse(month) - 1]}",
                    style: boldTextStyle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseServices()
                        .firebaseFirestore
                        .collection('pinext_users')
                        .doc(FirebaseServices().getUserId())
                        .collection('pinext_transactions')
                        .doc(year)
                        .collection(month)
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
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Text(
                          "No data found! :(",
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.4),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length > 6
                                  ? 6
                                  : snapshot.data!.docs.length,
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
                                            style: regularTextStyle.copyWith(
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
                                      color: customBlackColor.withOpacity(.05),
                                    )
                                  ],
                                );
                              }),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MenuFilterPill extends StatelessWidget {
  MenuFilterPill({
    Key? key,
    required this.filtertitle,
    required this.selectedFilter,
  }) : super(key: key);

  String filtertitle;
  String selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          context.read<HomepageCubit>().changeMenuFilter(
                filtertitle,
              );
        },
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            // vertical: 10,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selectedFilter == filtertitle ? customBlueColor : greyColor,
            borderRadius: BorderRadius.circular(
              defaultBorder,
            ),
          ),
          child: Text(
            filtertitle,
            style: boldTextStyle.copyWith(
              color: selectedFilter == filtertitle
                  ? whiteColor
                  : customBlackColor.withOpacity(.4),
            ),
          ),
        ),
      ),
    );
  }
}
