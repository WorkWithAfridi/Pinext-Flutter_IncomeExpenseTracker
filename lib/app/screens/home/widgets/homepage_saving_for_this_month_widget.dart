import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/services/date_time_services.dart';

class HomepageGetSavingsForThisMonthWidget extends StatelessWidget {
  const HomepageGetSavingsForThisMonthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Savings',
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
                    child: Container(
                      color: Colors.transparent,
                      width: double.maxFinite,
                      child: Column(
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
                              final regionState = context.watch<RegionCubit>().state;
                              if (state is AuthenticatedUserState) {
                                return Text(
                                  demoBlocState is DemoEnabledState
                                      ? '75000 ${regionState.countryData.symbol}'
                                      : '${state.monthlySavings} ${regionState.countryData.symbol}',
                                  style: boldTextStyle.copyWith(
                                    fontSize: 20,
                                  ),
                                );
                              }
                              return Text(
                                'Loading...',
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
                    child: Container(
                      color: Colors.transparent,
                      width: double.maxFinite,
                      child: Column(
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
                              final regionState = context.watch<RegionCubit>().state;
                              if (state is AuthenticatedUserState) {
                                return Text(
                                  demoBlocState is DemoEnabledState
                                      ? '100000 ${regionState.countryData.symbol}'
                                      : "${state.monthlyEarnings == "" ? "0000" : state.monthlyEarnings} ${regionState.countryData.symbol}",
                                  style: boldTextStyle.copyWith(
                                    fontSize: 20,
                                  ),
                                );
                              }
                              return Text(
                                'Loading...',
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
                  var amount = '';
                  if (state is AuthenticatedUserState) {
                    amount = state.monthlyEarnings == '0'
                        ? '0'
                        : ((double.parse(state.monthlySavings) / double.parse(state.monthlyEarnings)) * 100).ceil().toString();
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
                          text: demoBlocState is DemoEnabledState ? '75%' : '$amount%',
                          style: boldTextStyle.copyWith(color: customBlackColor),
                        ),
                        TextSpan(
                          text: ' of your earnings in ',
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.6),
                          ),
                        ),
                        TextSpan(
                          text: months[int.parse(currentMonth) - 1],
                          style: boldTextStyle.copyWith(color: customBlackColor),
                        ),
                        TextSpan(
                          text: '.',
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
