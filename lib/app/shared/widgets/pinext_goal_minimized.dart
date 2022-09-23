import 'package:flutter/material.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/domentions.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';
import '../../models/pinext_goal_model.dart';

class PinextGoalCardMinimized extends StatelessWidget {
  PinextGoalCardMinimized({
    Key? key,
    required this.pinextGoalModel,
  }) : super(key: key);

  late PinextGoalModel pinextGoalModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            "# Goal 1",
            style: boldTextStyle,
          ),
          const SizedBox(
            height: 2,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Save up ",
                  style: regularTextStyle.copyWith(
                    color: customBlackColor.withOpacity(.6),
                  ),
                ),
                TextSpan(
                  text: pinextGoalModel.amount,
                  style: boldTextStyle,
                ),
                TextSpan(
                  text: " TK. for ",
                  style: regularTextStyle.copyWith(
                    color: customBlackColor.withOpacity(.6),
                  ),
                ),
                TextSpan(
                  text: pinextGoalModel.title,
                  style: boldTextStyle,
                ),
                TextSpan(
                  text: " !",
                  style: regularTextStyle.copyWith(
                    color: customBlackColor.withOpacity(.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
