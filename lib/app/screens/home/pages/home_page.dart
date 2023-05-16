import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/homepage_cubit/homepage_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/home/widgets/homepage_expense_tracker_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_get_balance_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_get_past_transactions_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_goals_and_milestone_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_saving_for_this_month_widget.dart';
import 'package:pinext/app/screens/home/widgets/homepage_your_cards_widget.dart';
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
                                  color: customBlackColor.withOpacity(.6),
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
            const HomepageGetBalanceWidget(),
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
    );
  }
}









// class MenuFilterPill extends StatelessWidget {
//   MenuFilterPill({
//     super.key,
//     required this.filtertitle,
//     required this.selectedFilter,
//   });

//   String filtertitle;
//   String selectedFilter;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: GestureDetector(
//         onTap: () {
//           if (filtertitle != 'Overview') {
//             GetCustomSnackbar(
//               title: 'Snap',
//               message: 'The section is still under development.\nAnd will be updated at a later date!',
//               snackbarType: SnackbarType.info,
//               context: context,
//             );
//           } else {
//             context.read<HomepageCubit>().changeMenuFilter(
//                   filtertitle,
//                 );
//           }
//         },
//         child: Container(
//           height: 35,
//           padding: const EdgeInsets.symmetric(
//             horizontal: 15,
//             // vertical: 10,
//           ),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: selectedFilter == filtertitle ? primaryColor : greyColor,
//             borderRadius: BorderRadius.circular(
//               defaultBorder,
//             ),
//           ),
//           child: Text(
//             filtertitle,
//             style: boldTextStyle.copyWith(
//               color: selectedFilter == filtertitle ? whiteColor : customBlackColor.withOpacity(.4),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
