import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/services/date_time_services.dart';

class HomepageGetExpensesWidget extends StatelessWidget {
  const HomepageGetExpensesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expenses',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              demoBlocState is DemoEnabledState ? '- 3600 Tk' : '- ${state.dailyExpenses} Tk',
                              style: boldTextStyle.copyWith(
                                fontSize: 25,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          Text(
                            'Today',
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
                        color: primaryColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              demoBlocState is DemoEnabledState ? '- 10000 Tk' : '- ${state.weeklyExpenses} Tk',
                              style: boldTextStyle.copyWith(
                                fontSize: 25,
                                color: whiteColor.withOpacity(.8),
                              ),
                            ),
                          ),
                          Text(
                            'This week',
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
                      demoBlocState is DemoEnabledState ? '- 25000 Tk' : '- ${state.monthlyExpenses} Tk',
                      style: boldTextStyle.copyWith(
                        fontSize: 20,
                      ),
                    );
                  }
                  return Text(
                    'Loading...',
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
                'in ${months[int.parse(currentMonth) - 1]}.',
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
