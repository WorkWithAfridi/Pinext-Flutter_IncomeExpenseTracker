import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/add_transaction/add_transaction.dart';
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
      Navigator.pushNamedAndRemoveUntil(
        context,
        ROUTES.getHomeframeRoute,
        (route) => false,
      );
    } else if (!userSignedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ROUTES.getLoginRoute,
        (route) => false,
      );
    } else if (userSignedIn && mode == 'AddTransaction') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => AddTransactionScreen(
                  isAQuickAction: true,
                )),
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
        icon: "money",
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
        icon: "money",
      ),
      const ShortcutItem(
        type: "ViewTransactions",
        localizedTitle: "View transactions",
        icon: "archive",
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
      body: SizedBox(
        height: getHeight(context),
        width: getWidth(context),
        child: Center(
          child: Text(
            "Pinext",
            style: boldTextStyle.copyWith(fontSize: 50),
          ),
        ),
      ),
    );
  }
}
