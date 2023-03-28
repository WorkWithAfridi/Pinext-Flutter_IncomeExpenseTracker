import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/edit_budget_screen.dart';
import 'package:pinext/app/services/date_time_services.dart';

class GetBudgetEstimationsWidget extends StatelessWidget {
  const GetBudgetEstimationsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Estimations',
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your budget for ${months[int.parse(currentMonth) - 1]}',
                    style: regularTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.6),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final state = context.watch<UserBloc>().state;
                      final demoBlocState = context.watch<DemoBloc>().state;
                      return GestureDetector(
                        onTap: () {
                          if (state is AuthenticatedUserState) {
                            Navigator.push(
                              context,
                              CustomTransitionPageRoute(
                                childWidget: EditbudgetScreen(
                                  monthlyBudget: state.monthlyBudget,
                                  amountSpentSoFar: state.monthlyExpenses,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (state is AuthenticatedUserState)
                                Text(
                                  demoBlocState is DemoEnabledState ? '25000 Tk' : '${state.monthlyBudget} Tk',
                                  style: regularTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: darkPurpleColor,
                                  ),
                                )
                              else
                                const SizedBox.shrink(),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                AntIcons.editOutlined,
                                color: customBlackColor,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      );
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
                    color: primaryColor.withOpacity(.2),
                  ),
                  Builder(
                    builder: (context) {
                      final state = context.watch<UserBloc>().state;
                      final demoBlocState = context.watch<DemoBloc>().state;
                      if (state is AuthenticatedUserState) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            var budgetSpentPercentage = 0;
                            if (state.monthlyBudget == '000' || state.monthlyExpenses == '000') {
                              budgetSpentPercentage = 0;
                            } else {
                              budgetSpentPercentage =
                                  (constraints.maxWidth * (double.parse(state.monthlyExpenses) / double.parse(state.monthlyBudget))).toInt();
                            }
                            return Container(
                              height: 5,
                              width: demoBlocState is DemoEnabledState
                                  ? constraints.maxWidth * .5
                                  : state.monthlyBudget == '000'
                                      ? 0.0
                                      : budgetSpentPercentage.toDouble(),
                              decoration: BoxDecoration(
                                color: darkPurpleColor,
                                borderRadius: BorderRadius.circular(defaultBorder),
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Your have spent ',
                                style: regularTextStyle.copyWith(
                                  color: customBlackColor.withOpacity(.6),
                                ),
                              ),
                              TextSpan(
                                text: demoBlocState is DemoEnabledState
                                    ? '50%'
                                    : '${((double.parse(state.monthlyExpenses) / double.parse(state.monthlyBudget)) * 100).ceil()}%',
                                style: boldTextStyle.copyWith(
                                  color: Colors.red.withOpacity(.9),
                                ),
                              ),
                              TextSpan(
                                text: ' of your budget!',
                                style: regularTextStyle.copyWith(
                                  color: customBlackColor.withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          demoBlocState is DemoEnabledState ? '- 12500 Tk' : '- ${state.monthlyExpenses} Tk',
                          style: boldTextStyle.copyWith(
                            color: Colors.red.withOpacity(.9),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
