import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/bloc/homepage_cubit/homepage_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/home/widgets/homepage_expense_tracker_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_get_balance_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_get_past_transactions_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_goals_and_milestone_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_saving_for_this_month_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_your_cards_widget.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/shared/widgets/budget_estimations.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
    super.key,
  });

  Map<String, double> demoData = {
    'Office fare': 50,
    'Lunch': 150,
    'Snacks': 100,
    'Hangout': 80,
  };

  final List homepageFilters = ['Overview', 'Daily', 'Weekly', 'Monthly', 'Yearly'];

  String getGreetings() {
    final currentHour = DateTime.now().hour;
    if (currentHour > 0 && currentHour <= 5) {
      return 'Hello,';
    } else if (currentHour > 5 && currentHour <= 11) {
      return 'Good morning,';
    } else if (currentHour > 11 && currentHour <= 18) {
      return 'Good afternoon,';
    } else if (currentHour > 18 && currentHour <= 24) {
      return 'Good evening,';
    }
    return 'Hello';
  }

  @override
  Widget build(BuildContext context) {
    log('Current year is: $currentYear');
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeframeCubit>().openAddTransactionsPage(context);
        },
        backgroundColor: darkPurpleColor,
        child: const Icon(
          Icons.add,
          color: whiteColor,
          size: 18,
        ),
      ),
      body: SizedBox(
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
                    Builder(
                      builder: (context) {
                        final state = context.watch<UserBloc>().state;
                        final demoBlocState = context.watch<DemoBloc>().state;
                        if (state is AuthenticatedUserState) {
                          return Animate(
                            effects: const [
                              SlideEffect(),
                              FadeEffect(),
                            ],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TextButton(
                                //   onPressed: () => throw Exception(),
                                //   child: const Text('Throw Test Exception'),
                                // ),
                                Text(
                                  getGreetings(),
                                  style: regularTextStyle.copyWith(
                                    color: customBlackColor,
                                  ),
                                ),
                                Text(
                                  demoBlocState is DemoEnabledState ? 'Kyoto' : state.username,
                                  style: cursiveTextStyle.copyWith(
                                    fontSize: 30,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: HomepageGetBalanceWidget(
                  tapToOpenUpdateNetBalancePage: false,
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
                      // height: 16,
                      height: 12,
                    ),
                    GetBudgetEstimationsWidget(
                      isForHomePage: true,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const HomepageGetSavingsForThisMonthWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       'Overview',
                    //       style: boldTextStyle.copyWith(
                    //         fontSize: 20,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       height: 8,
                    //     ),
                    //     Container(
                    //       padding: const EdgeInsets.all(
                    //         defaultPadding,
                    //       ),
                    //       width: getWidth(context),
                    //       decoration: BoxDecoration(
                    //         color: greyColor,
                    //         borderRadius: BorderRadius.circular(
                    //           defaultBorder,
                    //         ),
                    //       ),
                    //       child: Column(
                    //         children: [
                    //           SingleChildScrollView(
                    //             scrollDirection: Axis.horizontal,
                    //             child: Row(
                    //               children: [
                    //                 StreamBuilder(
                    //                   stream: FirebaseServices()
                    //                       .firebaseFirestore
                    //                       .collection('pinext_users')
                    //                       .doc(FirebaseServices().getUserId())
                    //                       .collection('pinext_user_monthly_stats')
                    //                       .doc(currentYear)
                    //                       .collection('savings')
                    //                       .snapshots(),
                    //                   builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    //                     if (snapshot.connectionState == ConnectionState.waiting) {
                    //                       return const Center(
                    //                         child: SizedBox.shrink(),
                    //                       );
                    //                     }
                    //                     if (snapshot.data!.docs.isEmpty) {
                    //                       return const Center(
                    //                         child: Text('No data found!'),
                    //                       );
                    //                     }
                    //                     return SizedBox(
                    //                       height: 100,
                    //                       child: ListView.builder(
                    //                         itemCount: snapshot.data!.docs.length,
                    //                         shrinkWrap: true,
                    //                         scrollDirection: Axis.horizontal,
                    //                         physics: const NeverScrollableScrollPhysics(),
                    //                         itemBuilder: (context, index) {
                    //                           return Container(
                    //                             height: 90,
                    //                             padding: const EdgeInsets.symmetric(horizontal: 5),
                    //                             child: Column(
                    //                               mainAxisAlignment: MainAxisAlignment.end,
                    //                               children: [
                    //                                 Text(
                    //                                   'JAN',
                    //                                   style: regularTextStyle.copyWith(
                    //                                     fontSize: 10,
                    //                                     color: customBlackColor.withOpacity(.6),
                    //                                   ),
                    //                                 ),
                    //                                 const SizedBox(
                    //                                   height: 2,
                    //                                 ),
                    //                                 Text(
                    //                                   '${double.parse(snapshot.data!.docs[index].data()['amount'].toString()).floor()}${context.watch<RegionCubit>().state.countryData.symbol}',
                    //                                   style: regularTextStyle.copyWith(fontSize: 10),
                    //                                 ),
                    //                                 const SizedBox(
                    //                                   height: 8,
                    //                                 ),
                    //                                 Container(
                    //                                   height: 30,
                    //                                   width: 5,
                    //                                   decoration: const BoxDecoration(
                    //                                     color: darkPurpleColor,
                    //                                     borderRadius: BorderRadius.only(
                    //                                       topLeft: Radius.circular(defaultBorder),
                    //                                       topRight: Radius.circular(defaultBorder),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           );
                    //                         },
                    //                       ),
                    //                     );
                    //                   },
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Container(
                    //             height: 1,
                    //             width: double.maxFinite,
                    //             color: primaryColor.withOpacity(.3),
                    //           ),
                    //           Row(
                    //             children: [
                    //               const SizedBox(
                    //                 width: 30,
                    //               ),
                    //               Container(
                    //                 padding: const EdgeInsets.symmetric(horizontal: 5),
                    //                 child: Container(
                    //                   height: 30,
                    //                   width: 5,
                    //                   decoration: const BoxDecoration(
                    //                     color: Colors.redAccent,
                    //                     borderRadius: BorderRadius.only(
                    //                       bottomLeft: Radius.circular(defaultBorder),
                    //                       bottomRight: Radius.circular(defaultBorder),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 12,
                    ),
                    const HomepageGetExpensesWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    const HomepageGetPastTransactionsWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    const HomepageGetGoalsAndMilestonesWidget()
                  ],
                ),
              ),
              const HomepageGetYourCardsWidget(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
