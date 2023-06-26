import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/goals_and_milestones/view_goals_and_milestones_screen.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/select_region_page.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/widgets/get_delete_account_button.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/widgets/get_demo_mode_button.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/widgets/get_reset_account_button.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/widgets/get_settings_button_with_icon.dart';
import 'package:pinext/app/services/handlers/file_handler.dart';
import 'package:pinext/app/shared/widgets/custom_loader.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            SingleChildScrollView(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      child: Text(
                        'User',
                        style: regularTextStyle.copyWith(
                          fontSize: 12,
                          color: customBlackColor.withOpacity(.5),
                        ),
                        textAlign: TextAlign.center,
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
                      label: 'Goals & milestones',
                      icon: Icons.stop,
                      iconSize: 18,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      child: Text(
                        'Account',
                        style: regularTextStyle.copyWith(
                          fontSize: 12,
                          color: customBlackColor.withOpacity(.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                    const SizedBox(
                      height: 8,
                    ),
                    const GetResetAccountButton(),
                    const SizedBox(
                      height: 8,
                    ),
                    const GetDeleteAccountButton(),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      child: Text(
                        'App',
                        style: regularTextStyle.copyWith(
                          fontSize: 12,
                          color: customBlackColor.withOpacity(.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GetSettingsButtonWithIcon(
                      onTapFunction: () {
                        context.read<HomeframeCubit>().showAboutDialog(context);
                      },
                      label: 'About Pinext',
                      icon: Icons.question_mark,
                      iconSize: 18,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GetSettingsButtonWithIcon(
                      onTapFunction: () {
                        FileHandler().getPrivicyPolicyPdf();
                        GetCustomSnackbar(
                          title: 'Pinext-PrivicyPolicy',
                          message: 'Privicy pplicy is being generated. Please wait. :)',
                          snackbarType: SnackbarType.info,
                          context: context,
                        );
                      },
                      label: 'Privicy Policy',
                      icon: Icons.security,
                      iconSize: 18,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const GetDemoModeButton(),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      child: Text(
                        'Others',
                        style: regularTextStyle.copyWith(
                          fontSize: 12,
                          color: customBlackColor.withOpacity(.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is AuthenticatedUserState && state.isLoading) {
                  return const CustomLoader(title: 'Loading...');
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
