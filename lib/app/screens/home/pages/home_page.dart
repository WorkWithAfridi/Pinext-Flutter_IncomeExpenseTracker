import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/screens/goals_and_milestones/view_goals_and_milestones_screen.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/pinext_goal_minimized.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/custom_transition_page_route/custom_transition_page_route.dart';
import '../../../app_data/theme_data/colors.dart';
import '../../../bloc/archive_cubit/archive_cubit.dart';
import '../../../bloc/demoBloc/demo_bloc.dart';
import '../../../bloc/homeframe_cubit/homeframe_page_cubit.dart';
import '../../../bloc/homepage_cubit/homepage_cubit.dart';
import '../../../bloc/userBloc/user_bloc.dart';
import '../../../services/date_time_services.dart';
import '../../../shared/widgets/budget_estimations.dart';
import '../../../shared/widgets/pinext_card.dart';
import '../../../shared/widgets/transaction_details_card.dart';

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

  final List homepageFilters = ['Overview', 'Daily', 'Weekly', 'Monthly', 'Yearly'];

  Map<String, double> demoData = {
    "Office fare": 50,
    "Lunch": 150,
    "Snacks": 100,
    "Hangout": 80,
  };

  String getGreetings() {
    int currentHour = DateTime.now().hour;
    if (currentHour > 0 && currentHour <= 5) {
      return "Hello,";
    } else if (currentHour > 5 && currentHour <= 11) {
      return "Good morning,";
    } else if (currentHour > 11 && currentHour <= 18) {
      return "Good afternoon,";
    } else if (currentHour > 18 && currentHour <= 24) {
      return "Good evening,";
    }
    return "Hello";
  }

  @override
  Widget build(BuildContext context) {
    context.read<ArchiveCubit>().getCurrentMonthTransactionArchive(context);
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
                  Text(
                    getGreetings(),
                    style: regularTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.6),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      var state = context.watch<UserBloc>().state;
                      var demoBlocState = context.watch<DemoBloc>().state;
                      if (state is AuthenticatedUserState) {
                        return Text(
                          demoBlocState is DemoEnabledState ? "Kyoto" : state.username,
                          style: cursiveTextStyle.copyWith(
                            fontSize: 30,
                            color: customBlackColor.withOpacity(.8),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 40,
            //   child: SingleChildScrollView(
            //     physics: const BouncingScrollPhysics(),
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       children: [
            //         const SizedBox(
            //           width: defaultPadding,
            //         ),
            //         BlocBuilder<HomepageCubit, HomepageState>(
            //           builder: (context, state) {
            //             return ListView.builder(
            //               shrinkWrap: true,
            //               scrollDirection: Axis.horizontal,
            //               itemCount: homepageFilters.length,
            //               itemBuilder: ((context, index) {
            //                 return MenuFilterPill(
            //                   filtertitle: homepageFilters[index],
            //                   selectedFilter: state.selectedFilter,
            //                 );
            //               }),
            //             );
            //           },
            //         ),
            //         const SizedBox(
            //           width: defaultPadding - 10,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(
                    // height: 16,
                    height: 12,
                  ),
                  GetBudgetEstimationsWidget(),
                  SizedBox(
                    height: 12,
                  ),
                  _GetSavingsForThisMonthWidget(),
                  SizedBox(
                    height: 12,
                  ),
                  _GetExpensesWidget(),
                  SizedBox(
                    height: 12,
                  ),
                  _GetPastTransactionsWidget(),
                  SizedBox(
                    height: 12,
                  ),
                  _GetGoalsAndMilestonesWidget()
                ],
              ),
            ),
            const _GetYourCardsWidget(),
            const SizedBox(
              height: 12,
            ),
            const _GetBalanceWidget(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class _GetBalanceWidget extends StatelessWidget {
  const _GetBalanceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Balance",
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
                  "Your current NET. balance is",
                  style: regularTextStyle,
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
                        demoBlocState is DemoEnabledState ? "750000 Tk" : "${state.netBalance} Tk",
                        style: boldTextStyle.copyWith(
                          fontSize: 25,
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
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

class _GetGoalsAndMilestonesWidget extends StatelessWidget {
  const _GetGoalsAndMilestonesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Goals & milestones",
              style: boldTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CustomTransitionPageRoute(
                    childWidget: const ViewGoalsAndMilestoneScreen(),
                  ),
                );
              },
              child: Text(
                "View all",
                style: regularTextStyle.copyWith(
                  fontSize: 14,
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        StreamBuilder(
          stream: FirebaseServices()
              .firebaseFirestore
              .collection('pinext_users')
              .doc(FirebaseServices().getUserId())
              .collection('pinext_goals')
              .snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox.shrink(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Text(
                "404 - No record found!",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  itemCount: snapshot.data!.docs.length > 5 ? 5 : snapshot.data!.docs.length,
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

                    PinextGoalModel pinextGoalModel = PinextGoalModel.fromMap(
                      snapshot.data!.docs[index].data(),
                    );
                    return BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        double completionAmount = 0;
                        if (state is AuthenticatedUserState) {
                          completionAmount =
                              ((double.parse(state.netBalance) / double.parse(pinextGoalModel.amount)) * 100);
                        }
                        return completionAmount < 100
                            ? PinextGoalCardMinimized(
                                pinextGoalModel: pinextGoalModel,
                                index: index,
                                showCompletePercentage: true,
                              )
                            : const SizedBox.shrink();
                      },
                    );
                  }),
                )
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _GetExpensesWidget extends StatelessWidget {
  const _GetExpensesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Expenses",
          style: boldTextStyle.copyWith(
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Builder(
          builder: (context) {
            final state = context.watch<UserBloc>().state;
            final demoBlocState = context.watch<DemoBloc>().state;
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
                              demoBlocState is DemoEnabledState ? "- 3600 Tk" : "- ${state.dailyExpenses} Tk",
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
                              demoBlocState is DemoEnabledState ? "- 10000 Tk" : "- ${state.weeklyExpenses} Tk",
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
              return const SizedBox.shrink();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "You've spend",
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
                      demoBlocState is DemoEnabledState ? "- 25000 Tk" : "- ${state.monthlyExpenses} Tk",
                      style: boldTextStyle.copyWith(
                        fontSize: 20,
                      ),
                    );
                  }
                  return Text(
                    "Loading...",
                    style: boldTextStyle.copyWith(
                      fontSize: 25,
                      color: whiteColor.withOpacity(.8),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "in ${months[int.parse(currentMonth) - 1]}.",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GetSavingsForThisMonthWidget extends StatelessWidget {
  const _GetSavingsForThisMonthWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                            "You've saved",
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
                            "You've earned",
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
              Builder(
                builder: (context) {
                  final state = context.watch<UserBloc>().state;
                  final demoBlocState = context.watch<DemoBloc>().state;
                  String amount = "";
                  if (state is AuthenticatedUserState) {
                    amount = state.monthlyEarnings == "0"
                        ? "0"
                        : ((double.parse(state.monthlySavings) / double.parse(state.monthlyEarnings)) * 100)
                            .ceil()
                            .toString();
                  }
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "You've saved ",
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.6),
                          ),
                        ),
                        TextSpan(
                          text: demoBlocState is DemoEnabledState ? "75%" : "$amount%",
                          style: boldTextStyle.copyWith(color: customBlackColor),
                        ),
                        TextSpan(
                          text: " of your earnings in ",
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.6),
                          ),
                        ),
                        TextSpan(
                          text: "${months[int.parse(currentMonth) - 1]}",
                          style: boldTextStyle.copyWith(color: customBlackColor),
                        ),
                        TextSpan(
                          text: ".",
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GetPastTransactionsWidget extends StatelessWidget {
  const _GetPastTransactionsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Last 10 transactions",
              style: boldTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<HomeframeCubit>().changeHomeframePage(1);
              },
              child: Text(
                "View all",
                style: regularTextStyle.copyWith(
                  fontSize: 14,
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        BlocBuilder<ArchiveCubit, ArchiveState>(
          builder: (context, archiveState) {
            if (archiveState.archiveList.isEmpty) {
              return Text(
                "404 - No record found!",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              );
            }
            return ListView.builder(
              itemCount: archiveState.archiveList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return TransactionDetailsCard(
                  pinextTransactionModel: archiveState.archiveList[index],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _GetYourCardsWidget extends StatelessWidget {
  const _GetYourCardsWidget({
    Key? key,
  }) : super(key: key);

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
            children: [
              const SizedBox(
                height: 8,
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
        SingleChildScrollView(
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
                    .orderBy(
                      'lastTransactionData',
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
                      "Please add a Pinext card to view your cards details here.",
                      style: regularTextStyle.copyWith(
                        color: customBlackColor.withOpacity(.4),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 185,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        PinextCardModel pinextCardModel = PinextCardModel.fromMap(
                          snapshot.data!.docs[index].data(),
                        );

                        String color = pinextCardModel.color;
                        late Color cardColor = getColorFromString(color);

                        return PinextCard(
                          title: pinextCardModel.title,
                          balance: pinextCardModel.balance,
                          cardColor: cardColor,
                          lastTransactionDate: pinextCardModel.lastTransactionData,
                          cardDetails: pinextCardModel.description,
                          cardModel: pinextCardModel,
                        );
                      }),
                    ),
                  );
                }),
              ),
              const SizedBox(
                width: defaultPadding - 10,
              ),
            ],
          ),
        ),
      ],
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
          if (filtertitle != "Overview") {
            GetCustomSnackbar(
              title: "Snap",
              message: "The section is still under development.\nAnd will be updated at a later date!",
              snackbarType: SnackbarType.info,
              context: context,
            );
          } else {
            context.read<HomepageCubit>().changeMenuFilter(
                  filtertitle,
                );
          }
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
              color: selectedFilter == filtertitle ? whiteColor : customBlackColor.withOpacity(.4),
            ),
          ),
        ),
      ),
    );
  }
}
