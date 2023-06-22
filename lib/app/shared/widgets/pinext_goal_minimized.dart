import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/screens/goals_and_milestones/add_and_edit_goal_and_milestone_screen.dart';

class PinextGoalCardMinimized extends StatelessWidget {
  PinextGoalCardMinimized({
    required this.pinextGoalModel,
    required this.index,
    required this.showCompletePercentage,
    super.key,
  });

  late PinextGoalModel pinextGoalModel;
  late int index;
  late bool showCompletePercentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
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
            Builder(
              builder: (context) {
                final state = context.watch<UserBloc>().state;
                final demoBlocState = context.watch<DemoBloc>().state;
                if (state is AuthenticatedUserState) {
                  final completionAmount =
                      double.parse(state.netBalance) <= 0 ? 0 : ((double.parse(state.netBalance) / double.parse(pinextGoalModel.amount)) * 100).ceilToDouble();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '# Goal ${index + 1}',
                        style: boldTextStyle.copyWith(
                          decoration: completionAmount > 100 ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Status: ',
                                  style: regularTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.6),
                                    decoration: completionAmount > 100 ? TextDecoration.lineThrough : TextDecoration.none,
                                  ),
                                ),
                                TextSpan(
                                  text: completionAmount < 100 ? 'Ongoing' : 'Completed',
                                  style: boldTextStyle.copyWith(
                                    color: completionAmount < 100 ? Colors.red : Colors.green,
                                    decoration: completionAmount > 100 ? TextDecoration.lineThrough : TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (demoBlocState is DemoDisabledState) {
                                Navigator.push(
                                  context,
                                  CustomTransitionPageRoute(
                                    childWidget: AddAndEditGoalsAndMilestoneScreen(
                                      addingNewGoal: false,
                                      addingNewGoalDuringSignupProcess: false,
                                      editingGoal: true,
                                      pinextGoalModel: pinextGoalModel,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  AntIcons.editOutlined,
                                  color: primaryColor,
                                  size: 16,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(
              height: 4,
            ),
            Builder(
              builder: (context) {
                final state = context.watch<UserBloc>().state;
                final demoBlocState = context.watch<DemoBloc>().state;
                final regionState = context.watch<RegionCubit>().state;

                var completionAmount = 0;
                if (state is AuthenticatedUserState) {
                  completionAmount = double.parse(state.netBalance) <= 0
                      ? 0
                      : ((double.parse(state.netBalance) / (double.parse(pinextGoalModel.amount) - .005)) * 100).toInt();
                }
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Save up ',
                        style: regularTextStyle.copyWith(
                          color: customBlackColor.withOpacity(.6),
                          decoration: completionAmount > 100 ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: demoBlocState is DemoEnabledState ? '25000' : pinextGoalModel.amount,
                        style: boldTextStyle.copyWith(
                          decoration: completionAmount > 100 ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: ' ${regionState.countryData.symbol} for ',
                        style: boldTextStyle.copyWith(
                          decoration: completionAmount > 100 ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: demoBlocState is DemoEnabledState ? 'a new MacBook' : pinextGoalModel.title,
                        style: boldTextStyle.copyWith(
                          decoration: completionAmount > 100 ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: '!',
                        style: regularTextStyle.copyWith(
                          color: customBlackColor.withOpacity(.6),
                          decoration: completionAmount > 100 ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is AuthenticatedUserState) {
                      return LayoutBuilder(
                        builder: (context, constradoubles) {
                          return Container(
                            height: 5,
                            width: (constradoubles.maxWidth *
                                    ((double.parse(state.netBalance) /
                                            double.parse(
                                              pinextGoalModel.amount,
                                            )) *
                                        100)) /
                                100,
                            color: primaryColor,
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
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is AuthenticatedUserState) {
                  final completionAmount =
                      double.parse(state.netBalance) <= 0.0 ? 0 : ((double.parse(state.netBalance) / double.parse(pinextGoalModel.amount)) * 100);
                  if (completionAmount > 100) {
                    return const SizedBox.shrink();
                  } else {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your have completed ',
                            style: regularTextStyle.copyWith(
                              color: customBlackColor.withOpacity(.6),
                            ),
                          ),
                          TextSpan(
                            text: double.parse(state.netBalance) <= 0
                                ? '0%'
                                : '${((double.parse(state.netBalance) / (double.parse(pinextGoalModel.amount) - .005)) * 100).toString().substring(0, 4)}%',
                            style: boldTextStyle.copyWith(
                              color: Colors.red.withOpacity(.9),
                            ),
                          ),
                          TextSpan(
                            text: ' of your GOAL!',
                            style: regularTextStyle.copyWith(
                              color: customBlackColor.withOpacity(.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
