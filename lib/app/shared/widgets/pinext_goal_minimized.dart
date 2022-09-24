import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/domentions.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';
import '../../bloc/userBloc/user_bloc.dart';
import '../../models/pinext_goal_model.dart';

class PinextGoalCardMinimized extends StatelessWidget {
  PinextGoalCardMinimized(
      {Key? key,
      required this.pinextGoalModel,
      required this.index,
      required this.showCompletePercentage})
      : super(key: key);

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
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is AuthenticatedUserState) {
                  double completionAmount = ((double.parse(state.netBalance) /
                          double.parse(pinextGoalModel.amount)) *
                      100);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "# Goal ${index + 1}",
                        style: boldTextStyle.copyWith(
                          decoration: completionAmount > 100
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Status: ",
                              style: regularTextStyle.copyWith(
                                color: customBlackColor.withOpacity(.6),
                                decoration: completionAmount > 100
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            TextSpan(
                              text: completionAmount < 100
                                  ? "Ongoing"
                                  : "Completed",
                              style: boldTextStyle.copyWith(
                                color: completionAmount < 100
                                    ? Colors.red
                                    : Colors.green,
                                decoration: completionAmount > 100
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
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
              height: 4,
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                double completionAmount = 0;
                if (state is AuthenticatedUserState) {
                  completionAmount = ((double.parse(state.netBalance) /
                          double.parse(pinextGoalModel.amount)) *
                      100);
                }
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Save up ",
                        style: regularTextStyle.copyWith(
                          color: customBlackColor.withOpacity(.6),
                          decoration: completionAmount > 100
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: pinextGoalModel.amount,
                        style: boldTextStyle.copyWith(
                          decoration: completionAmount > 100
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: " TK. for ",
                        style: regularTextStyle.copyWith(
                          color: customBlackColor.withOpacity(.6),
                          decoration: completionAmount > 100
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: pinextGoalModel.title,
                        style: boldTextStyle.copyWith(
                          decoration: completionAmount > 100
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: "!",
                        style: regularTextStyle.copyWith(
                          color: customBlackColor.withOpacity(.6),
                          decoration: completionAmount > 100
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
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
                  color: customBlueColor.withOpacity(.2),
                ),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is AuthenticatedUserState) {
                      return LayoutBuilder(
                        builder: ((context, constraints) {
                          log((constraints.maxWidth *
                                  (double.parse(pinextGoalModel.amount) /
                                      double.parse(state.netBalance)) /
                                  100)
                              .toString());
                          return Container(
                            height: 5,
                            width: (constraints.maxWidth *
                                    ((double.parse(state.netBalance) /
                                            double.parse(
                                                pinextGoalModel.amount)) *
                                        100)) /
                                100,
                            color: customBlueColor,
                          );
                        }),
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
                  double completionAmount = ((double.parse(state.netBalance) /
                          double.parse(pinextGoalModel.amount)) *
                      100);
                  if (completionAmount > 100) {
                    return const SizedBox.shrink();
                  } else {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Your have completed ",
                            style: regularTextStyle.copyWith(
                              color: customBlackColor.withOpacity(.6),
                            ),
                          ),
                          TextSpan(
                            text:
                                "${((double.parse(state.netBalance) / double.parse(pinextGoalModel.amount)) * 100).toString().substring(0, 4)}%",
                            style: boldTextStyle.copyWith(
                              color: Colors.red.withOpacity(.9),
                            ),
                          ),
                          TextSpan(
                            text: " of your GOAL!",
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
