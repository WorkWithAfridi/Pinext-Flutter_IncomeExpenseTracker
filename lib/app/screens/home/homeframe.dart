import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:pinext/app/app_data/app_constants/app_labels.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/home/pages/archive_page.dart';
import 'package:pinext/app/screens/home/pages/cards_and_balance_page.dart';
import 'package:pinext/app/screens/home/pages/home_page.dart';
import 'package:pinext/app/services/authentication_services.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../bloc/homeframe_cubit/homeframe_page_cubit.dart';
import '../../services/handlers/app_handler.dart';

class Homeframe extends StatefulWidget {
  const Homeframe({Key? key}) : super(key: key);

  @override
  State<Homeframe> createState() => _HomeframeState();
}

class _HomeframeState extends State<Homeframe> {
  @override
  void initState() {
    super.initState();
    // AppHandler().checkForUpdate(context);
    showIntroductions();
  }

  showIntroductions() async {
    bool isFirstBoot = await AppHandler().checkIfFirstBoot();
    log(isFirstBoot.toString());
    if (isFirstBoot) {
      triggerIntroduction();
    }
  }

  triggerIntroduction() async {
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
        )
      ],
      child: HomeframeView(),
    );
  }
}

List homeframePages = [
  const Homepage(),
  const ArchivePage(),
  const CardsAndBalancePage(),
  Center(
    child: Text(
      "The section is still under development.\nPlease standby for future updates!",
      style: regularTextStyle.copyWith(color: customBlackColor.withOpacity(.2)),
      textAlign: TextAlign.center,
    ),
  ),
];

class HomeframeView extends StatelessWidget {
  HomeframeView({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
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
              builder: (context, key) {
                return Icon(
                  key: key,
                  Icons.menu,
                  color: customBlackColor,
                );
              }),
        ),
      ),
      drawer: const PinextDrawer(),
      body: BlocBuilder<HomeframeCubit, HomeframeState>(
        builder: (context, state) {
          return PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: homeframePages.length,
            controller: state.pageController,
            onPageChanged: ((value) {
              context.read<HomeframeCubit>().changeHomeframePage(value);
            }),
            itemBuilder: ((context, index) => homeframePages[index]),
          );
        },
      ),
      floatingActionButton: IntroStepBuilder(
          order: 1,
          text: intro_label_one,
          builder: (context, key) {
            return BlocBuilder<HomeframeCubit, HomeframeState>(
              key: key,
              builder: (context, state) {
                return state.selectedIndex == 0
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            ROUTES.getAddTransactionsRoute,
                          );
                        },
                        backgroundColor: customBlackColor,
                        child: const Icon(
                          Icons.add,
                          color: whiteColor,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      bottomNavigationBar: BlocBuilder<HomeframeCubit, HomeframeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            key: key,
            currentIndex: state.selectedIndex,
            onTap: (value) {
              context.read<HomeframeCubit>().changeHomeframePage(value);
            },
            selectedItemColor: customBlueColor,
            unselectedItemColor: customBlackColor.withOpacity(.4),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                    order: 2,
                    text: intro_label_two,
                    builder: (context, key) {
                      return Icon(
                        key: key,
                        Icons.home,
                      );
                    }),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                    order: 3,
                    text: intro_label_three,
                    builder: (context, key) {
                      return Icon(
                        key: key,
                        Icons.list,
                      );
                    }),
                label: "Archive",
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                    order: 4,
                    text: intro_label_four,
                    builder: (context, key) {
                      return Icon(
                        key: key,
                        Icons.wallet,
                      );
                    }),
                label: "Wallet",
              ),
              BottomNavigationBarItem(
                icon: IntroStepBuilder(
                    order: 5,
                    text: intro_label_five,
                    builder: (context, key) {
                      return Icon(
                        key: key,
                        Icons.person,
                      );
                    }),
                label: "User",
              ),
            ],
          );
        },
      ),
    );
  }
}

class PinextDrawer extends StatelessWidget {
  const PinextDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: getHeight(context),
        color: greyColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Pinext",
                        style: regularTextStyle.copyWith(
                          height: .9,
                          color: customBlackColor.withOpacity(.6),
                        ),
                      ),
                      Text(
                        "Space",
                        style: boldTextStyle.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "By",
                        style: regularTextStyle.copyWith(
                          fontSize: 12,
                          color: customBlackColor.withOpacity(.4),
                        ),
                      ),
                      Text(
                        "KYOTO",
                        style: regularTextStyle.copyWith(
                          fontSize: 14,
                          color: customBlackColor.withOpacity(.4),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    bool userSignedOutSuccessfully =
                        await AuthenticationServices().signOutUser();
                    if (userSignedOutSuccessfully) {
                      context.read<UserBloc>().add(SignOutUserEvent());
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        ROUTES.getLoginRoute,
                        (route) => false,
                      );
                    } else {
                      GetCustomSnackbar(
                        title: "Snap",
                        message:
                            "An error occurred while trying to sign you out! Please try closing the app and opening it again.",
                        snackbarType: SnackbarType.info,
                        context: context,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: customBlackColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
