import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/screens/goals_and_milestones/view_goals_and_milestones_screen.dart';
import 'package:pinext/app/services/handlers/app_handler.dart';

import '../../../../app_data/appVersion.dart';
import '../../../../app_data/app_constants/domentions.dart';
import '../../../../app_data/custom_transition_page_route/custom_transition_page_route.dart';
import '../../../../app_data/theme_data/colors.dart';
import '../../../../services/handlers/user_handler.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Hello,\n",
                  style: regularTextStyle.copyWith(
                    color: customBlackColor.withOpacity(.6),
                  ),
                ),
                TextSpan(
                  text: "${UserHandler().currentUser.username} 👋",
                  style: cursiveTextStyle.copyWith(
                    // height: .95,
                    fontSize: 30,
                    color: customBlackColor.withOpacity(.8),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 8,
          // ),
          // GetSettingsButtonWithIcon(
          //   onTapFunction: () {
          //     GetCustomSnackbar(
          //       title: "Snap",
          //       message:
          //           "The section is still under development.\nAnd will be updated at a later date!",
          //       snackbarType: SnackbarType.info,
          //       context: context,
          //     );
          //   },
          //   label: "${UserHandler().currentUser.username} - User settings",
          //   icon: Icons.person,
          //   iconSize: 18,
          // ),
          const SizedBox(
            height: 8,
          ),
          GetSettingsButtonWithIcon(
            onTapFunction: () {
              Navigator.push(
                context,
                CustomTransitionPageRoute(
                  childWidget: const ViewGoalsAndMilestoneScreen(),
                ),
              );
            },
            label: "Goals & Milestones",
            icon: Icons.stop,
            iconSize: 18,
          ),
          // const SizedBox(
          //   height: 8,
          // ),
          // GetSettingsButtonWithIcon(
          //   onTapFunction: () {
          //     GetCustomSnackbar(
          //       title: "Snap",
          //       message:
          //           "The section is still under development.\nAnd will be updated at a later date!",
          //       snackbarType: SnackbarType.info,
          //       context: context,
          //     );
          //   },
          //   label: "App settings",
          //   icon: Icons.settings,
          //   iconSize: 18,
          // ),
          const SizedBox(
            height: 8,
          ),
          GetSettingsButtonWithIcon(
            onTapFunction: () {
              AppHandler().requestNewFuture(context);
            },
            label: "Request new future!",
            icon: FontAwesomeIcons.fire,
            iconSize: 16,
          ),
          const SizedBox(
            height: 8,
          ),
          GetSettingsButtonWithIcon(
            onTapFunction: () {
              AppHandler().writeReview(context);
            },
            label: "Post review",
            icon: Icons.edit,
            iconSize: 18,
          ),
          const SizedBox(
            height: 8,
          ),
          GetSettingsButtonWithIcon(
            onTapFunction: () {
              AppHandler().checkForUpdate(context);
            },
            label: "Check for updates",
            icon: Icons.update,
            iconSize: 18,
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
            ),
            child: Text(
              "App Version: $appVersion",
              style: regularTextStyle.copyWith(
                fontSize: 12,
                color: customBlackColor.withOpacity(.2),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            " by Kyoto",
            style: cursiveTextStyle.copyWith(
              // height: .95,
              fontSize: 16,
              color: customBlackColor.withOpacity(.2),
            ),
          )
        ],
      ),
    );
  }
}

class GetSettingsButtonWithIcon extends StatelessWidget {
  GetSettingsButtonWithIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTapFunction,
    required this.iconSize,
  }) : super(key: key);

  IconData icon;
  String label;
  Function onTapFunction;
  double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapFunction();
      },
      child: Container(
        height: 50,
        width: getWidth(context),
        decoration: BoxDecoration(
          color: greyColor,
          borderRadius: BorderRadius.circular(defaultBorder),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: customBlackColor,
              size: iconSize,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              label,
              style: regularTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
