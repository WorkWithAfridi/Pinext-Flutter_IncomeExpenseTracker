import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/add_and_view_transaction/add_and_view_transaction.dart';
import 'package:pinext/app/services/authentication_services.dart';
import 'package:quick_actions/quick_actions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void triggerSplashScreenAnimation(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: defaultDelayDuration),
    );
    userSignedIn = await AuthenticationServices().isUserSignedIn();
    if (userSignedIn && mode == 'default') {
      context.read<UserBloc>().add(RefreshUserStateEvent());
    } else if (!userSignedIn) {
      context.read<UserBloc>().add(UnauthenticatedUserEvent());
    } else if (userSignedIn && mode == 'AddTransaction') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AddAndViewTransactionScreen(
            isAQuickAction: true,
          ),
        ),
        (route) => false,
      );
    }
  }

  String mode = 'default';

  bool userSignedIn = false;

  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType.toString() == "AddTransaction") {
        log("AddTransaction");
        setState(() {
          mode = "AddTransaction";
        });
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: "AddTransaction",
        localizedTitle: "Add transaction",
        icon: "@drawable/money_icon",
      ),
    ]);

    triggerSplashScreenAnimation(context);
  }

  setUpQuickActions() {
    QuickActions quickActions = const QuickActions();
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: "AddTransaction",
        localizedTitle: "Add transaction",
        icon: "@drawable/money_icon",
      ),
      const ShortcutItem(
        type: "ViewTransactions",
        localizedTitle: "View transactions",
        icon: "@drawable/history_icon",
      ),
    ]);
    quickActions.initialize((String shortcutType) async {
      if (shortcutType == "AddTransaction") {
        if (userSignedIn) {
          Navigator.pushNamed(context, ROUTES.getAddTransactionsRoute);
        }
      }
      if (shortcutType == "ViewTransactions") {
        if (userSignedIn) {
          context.read<HomeframeCubit>().changeHomeframePage(1);
          Navigator.pushNamed(context, ROUTES.getHomeframeRoute);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customBlueColor,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is AuthenticatedUserState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ROUTES.getHomeframeRoute,
              (route) => false,
            );
          } else if (state is UnauthenticatedUserState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ROUTES.getLoginRoute,
              (route) => false,
            );
          }
        },
        child: SizedBox(
          height: getHeight(context),
          width: getWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Pinext",
                style: boldTextStyle.copyWith(
                  fontSize: 50,
                  color: whiteColor,
                  height: .9,
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Flexible(
              //       flex: 1,
              //       child: Container(
              //         alignment: Alignment.centerRight,
              //         width: double.maxFinite,
              //         child: Text(
              //           "Pin",
              //           style: boldTextStyle.copyWith(
              //             fontSize: 50,
              //             color: whiteColor,
              //             height: .9,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Flexible(
              //       flex: 1,
              //       child: Container(
              //         height: MediaQuery.of(context).size.height,
              //         width: double.maxFinite,
              //         decoration: const BoxDecoration(
              //           // borderRadius: BorderRadius.circular(defaultBorder),
              //           color: whiteColor,
              //         ),
              //         alignment: Alignment.centerLeft,
              //         child: Text(
              //           "ext",
              //           style: boldTextStyle.copyWith(
              //             fontSize: 50,
              //             color: customBlackColor,
              //             height: .9,
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
