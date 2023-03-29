import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinext/app/app_data/app_constants/app_labels.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/app_settings_screen.dart';
import 'package:pinext/app/screens/home/pages/archive_page.dart';
import 'package:pinext/app/screens/home/pages/budget_page.dart';
import 'package:pinext/app/screens/home/pages/budget_pages/add_subscription_page.dart';
import 'package:pinext/app/screens/home/pages/cards_and_balance_page.dart';
import 'package:pinext/app/screens/home/pages/home_page.dart';
import 'package:pinext/app/services/handlers/app_handler.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';

class Homeframe extends StatefulWidget {
  const Homeframe({super.key});

  @override
  State<Homeframe> createState() => _HomeframeState();
}

class _HomeframeState extends State<Homeframe> {
  @override
  void initState() {
    super.initState();
    CardHandler().getUserCards();

    context.read<ArchiveCubit>().getCurrentMonthTransactionArchive(context);
    // AppHandler().checkForUpdate(context);
    // showIntroductions();
    //Add introKeys to children widgets
  }

  Future<void> showIntroductions() async {
    final isFirstBoot = await AppHandler().checkIfFirstBoot();
    if (isFirstBoot) {
      await triggerIntroduction();
    }
  }

  Future<void> triggerIntroduction() async {
    await Future.delayed(const Duration(seconds: 1)).then((_) {
      Intro.of(context).start();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeframeCubit(),
        ),
      ],
      child: HomeframeView(),
    );
  }
}

List homeframePages = [const Homepage(), const ArchivePage(), const BudgetPage(), const CardsAndBalancePage(), const AppSettingsScreen()];

checkIfOldUser() {}

class HomeframeView extends StatelessWidget {
  HomeframeView({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeframeCubit, HomeframeState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: IntroStepBuilder(
                order: 6,
                text: intro_label_six,
                builder: (context, introkey) {
                  return const Icon(
                    Icons.menu,
                    color: customBlackColor,
                  );
                },
              ),
            ),
            centerTitle: true,
            title: Builder(
              builder: (context) {
                final demoBlocState = context.watch<DemoBloc>().state;
                return Text(
                  demoBlocState is DemoEnabledState ? 'PINEXT : DEMO-MODE' : 'PINEXT',
                  style: regularTextStyle.copyWith(
                    fontSize: 20,
                  ),
                );
              },
            ),
          ),
          drawer: const PinextDrawer(),
          body: PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: homeframePages.length,
            controller: state.pageController,
            onPageChanged: (value) {
              context.read<HomeframeCubit>().changeHomeframePage(value);
            },
            itemBuilder: (context, index) => homeframePages[index] as Widget,
          ),
          floatingActionButton: state.selectedIndex == 0 || state.selectedIndex == 2
              ? IntroStepBuilder(
                  order: 1,
                  text: intro_label_one,
                  builder: (context, introkey) {
                    return FloatingActionButton(
                      onPressed: () {
                        if (state.selectedIndex == 0) {
                          context.read<HomeframeCubit>().openAddTransactionsPage(context);
                        } else if (state.selectedIndex == 2) {
                          Navigator.push(
                            context,
                            CustomTransitionPageRoute(
                              childWidget: AddSubscriptionPage(),
                            ),
                          );
                        }
                      },
                      backgroundColor: customBlackColor,
                      child: const Icon(
                        Icons.add,
                        color: whiteColor,
                        size: 16,
                      ),
                    );
                  },
                )
              : state.selectedIndex == 4
                  ? FloatingActionButton(
                      onPressed: () {
                        context.read<HomeframeCubit>().showAboutDialog(context);
                      },
                      backgroundColor: customBlackColor,
                      child: Text(
                        '?',
                        style: boldTextStyle.copyWith(
                          color: whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
          floatingActionButtonLocation: state.selectedIndex != 4 ? FloatingActionButtonLocation.miniEndTop : FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: BottomNavigationBar(
            key: key,
            currentIndex: state.selectedIndex,
            onTap: (value) {
              context.read<HomeframeCubit>().changeHomeframePage(value);
            },
            selectedItemColor: customBlueColor,
            unselectedItemColor: customBlackColor.withOpacity(.4),
            type: BottomNavigationBarType.fixed,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            selectedLabelStyle: regularTextStyle,
            unselectedLabelStyle: regularTextStyle.copyWith(fontSize: 10),
            items: [
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                  order: 2,
                  text: intro_label_two,
                  builder: (context, introkey) {
                    return Icon(
                      Icons.home,
                      size: state.selectedIndex == 0 ? 20 : 16,
                    );
                  },
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                  order: 3,
                  text: intro_label_three,
                  builder: (context, introkey) {
                    return Icon(
                      Icons.list,
                      size: state.selectedIndex == 1 ? 20 : 16,
                    );
                  },
                ),
                label: 'Archive',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.dollarSign,
                  size: state.selectedIndex == 2 ? 20 : 16,
                ),
                label: 'Budget',
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                  order: 4,
                  text: intro_label_four,
                  builder: (context, introkey) {
                    return Icon(
                      Icons.wallet,
                      size: state.selectedIndex == 3 ? 20 : 16,
                    );
                  },
                ),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                  order: 5,
                  text: intro_label_five,
                  builder: (context, introkey) {
                    return Icon(
                      Icons.more_horiz,
                      size: state.selectedIndex == 4 ? 20 : 16,
                    );
                  },
                ),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}

class PinextDrawer extends StatelessWidget {
  const PinextDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: getHeight(context),
        color: greyColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Pinext',
                        style: regularTextStyle.copyWith(
                          height: .9,
                          color: customBlackColor.withOpacity(.6),
                        ),
                      ),
                      Text(
                        'Space',
                        style: boldTextStyle.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          AppHandler().openPortfolio(context);
                        },
                        child: Column(
                          children: [
                            Text(
                              'By',
                              style: regularTextStyle.copyWith(
                                fontSize: 20,
                                color: customBlackColor.withOpacity(.4),
                              ),
                            ),
                            Text(
                              'KYOTO',
                              style: regularTextStyle.copyWith(
                                fontSize: 12,
                                color: customBlackColor.withOpacity(.4),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                IconButton(
                  onPressed: () {
                    AppHandler().sendBugReport(context);
                  },
                  icon: Icon(
                    FontAwesomeIcons.bug,
                    size: 20,
                    color: customBlackColor.withOpacity(.8),
                  ),
                ),
                // const SizedBox(
                //   height: 8,
                // ),
                // IconButton(
                //   onPressed: () {
                //     AppHandler().checkForUpdate(context);
                //   },
                //   icon: Icon(
                //     Icons.update,
                //     size: 20,
                //     color: customBlackColor.withOpacity(.8),
                //   ),
                // ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                  child: IconButton(
                    onPressed: () async {
                      context.read<UserBloc>().add(
                            SignOutUserEvent(context: context),
                          );
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.redAccent[400],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
