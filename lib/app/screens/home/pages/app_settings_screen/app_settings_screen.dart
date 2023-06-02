import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinext/app/app_data/appVersion.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/goals_and_milestones/view_goals_and_milestones_screen.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/select_region_page.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Animate(
                effects: const [
                  SlideEffect(),
                  FadeEffect(),
                ],
                child: Text(
                  'Settings',
                  style: cursiveTextStyle.copyWith(
                    fontSize: 30,
                    color: primaryColor,
                  ),
                ),
              ),
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
                label: 'Goals & Milestones',
                icon: Icons.stop,
                iconSize: 18,
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CustomTransitionPageRoute(
                      childWidget: SelectRegionScreen(
                        isUpdateUserRegion: true,
                      ),
                    ),
                  );
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Region ',
                        style: regularTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      BlocBuilder<RegionCubit, RegionState>(
                        builder: (context, state) {
                          return Text(
                            // UserHandler().currentUser.currencySymbol,
                            state.countryData.code,
                            style: regularTextStyle.copyWith(
                              fontSize: 15,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // const SizedBox(
              //   height: 8,
              // ),
              // GetSettingsButtonWithIcon(
              //   onTapFunction: () async {
              //     // final countryHandler = CountryHandler();
              //     // log(countryHandler.countryList.length.toString());
              //     // final bangladesh = countryHandler.countryList.where((element) => element.code == 'BD').first;
              //     // log('Currency of Bangladesh is ${bangladesh.symbol}');

              //     // final ipData = await ApiRepo().printIps();
              //     // log(ipData.toString());
              //   },
              //   label: 'Country data',
              //   icon: Icons.settings,
              //   iconSize: 18,
              // ),

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
              // const SizedBox(
              //   height: 8,
              // ),
              // GetSettingsButtonWithIcon(
              //   onTapFunction: () {
              //     AppHandler().requestNewFuture(context);
              //   },
              //   label: 'Request new future!',
              //   icon: FontAwesomeIcons.fire,
              //   iconSize: 16,
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // GetSettingsButtonWithIcon(
              //   onTapFunction: () {
              //     AppHandler().writeReview(context);
              //   },
              //   label: 'Post review',
              //   icon: FontAwesomeIcons.penToSquare,
              //   iconSize: 18,
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // GetSettingsButtonWithIcon(
              //   onTapFunction: () {
              //     AppHandler().sendBugReport(context);
              //   },
              //   label: 'Report bug',
              //   icon: FontAwesomeIcons.bug,
              //   iconSize: 18,
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // GetSettingsButtonWithIcon(
              //   onTapFunction: () {
              //     AppHandler().checkForUpdate(context);
              //   },
              //   label: 'Check for updates',
              //   icon: Icons.update,
              //   iconSize: 18,
              // ),
              const SizedBox(
                height: 8,
              ),
              BlocBuilder<DemoBloc, DemoState>(
                builder: (context, state) {
                  return GetSettingsButtonWithIcon(
                    onTapFunction: () async {
                      var status = '';
                      if (state is DemoEnabledState) {
                        context.read<DemoBloc>().add(DisableDemoModeEvent());
                        status = 'disabled';
                      } else {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Presentation Mode',
                                style: boldTextStyle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text(
                                      'Enabling Presentation Mode entails a temporary substitution of all your data with a template, facilitating the presentation or demonstration of the application to prospective users. It is possible to disable Presentation Mode at any given time through this menu. Given the aforementioned information, would you like to proceed with this action?',
                                      style: regularTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(defaultBorder),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Dismiss',
                                    style: boldTextStyle.copyWith(
                                      color: customBlackColor.withOpacity(
                                        .8,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    status = '';
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Enable',
                                    style: boldTextStyle.copyWith(
                                      color: customBlackColor.withOpacity(
                                        .8,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    status = 'enabled';
                                    context.read<DemoBloc>().add(EnableDemoModeEvent());
                                  },
                                ),
                              ],
                              actionsPadding: dialogButtonPadding,
                            );
                          },
                        );
                      }
                      if (status != '') {
                        GetCustomSnackbar(
                          title: 'DEMO-MODE',
                          message: 'Presentation mode has been $status.',
                          snackbarType: SnackbarType.info,
                          context: context,
                        );
                      }
                    },
                    label: state is DemoEnabledState ? 'Disable presentation mode' : 'Enable presentation mode',
                    icon: state is DemoEnabledState ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                    iconSize: 18,
                  );
                },
              ),
              const SizedBox(
                height: 8,
              ),
              BlocListener<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UnauthenticatedUserState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ROUTES.getLoginRoute,
                      (route) => false,
                    );
                  }
                },
                child: GetSettingsButtonWithIcon(
                  onTapFunction: () {
                    context.read<UserBloc>().add(
                          SignOutUserEvent(context: context),
                        );
                  },
                  label: 'Logout',
                  icon: Icons.logout,
                  iconSize: 18,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                child: Text(
                  'App Version: $appVersion',
                  style: regularTextStyle.copyWith(
                    fontSize: 12,
                    color: customBlackColor.withOpacity(.2),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // const SizedBox(height: 3),
              // GestureDetector(
              //   onTap: () {
              //     AppHandler().openPortfolio(context);
              //   },
              //   child: Text(
              //     ' by Kyoto',
              //     style: cursiveTextStyle.copyWith(
              //       // height: .95,
              //       fontSize: 16,
              //       color: customBlackColor.withOpacity(.2),
              //     ),
              //   ),
              // ),
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

class GetSettingsButtonWithIcon extends StatelessWidget {
  GetSettingsButtonWithIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onTapFunction,
    required this.iconSize,
  });

  IconData icon;
  double iconSize;
  String label;
  Function onTapFunction;

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: regularTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
            Icon(
              icon,
              color: customBlackColor,
              size: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
