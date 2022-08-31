import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
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
    if (userSignedIn) {
      context.read<UserBloc>().add(RefreshUserStateEvent());
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ROUTES.getLoginRoute,
        (route) => false,
      );
    }
  }

  String shortcut = "none";

  bool userSignedIn = false;

  @override
  void initState() {
    super.initState();
    setUpQuickActions();
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
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is AuthenticatedUserState) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ROUTES.getHomeframeRoute,
                  (route) => false,
                );
              }
            },
            child: Text(
              "Pinext",
              style: boldTextStyle.copyWith(fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }
}
