import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/add_and_view_transaction/add_and_view_transaction.dart';
import 'package:pinext/app/services/authentication_services.dart';
import 'package:quick_actions/quick_actions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> triggerSplashScreenAnimation(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: defaultDelayDuration),
    );
    userSignedIn = await AuthenticationServices().isUserSignedIn();
    if (userSignedIn && mode == 'default') {
      context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
    } else if (!userSignedIn) {
      context.read<UserBloc>().add(UnauthenticatedUserEvent());
    } else if (userSignedIn && mode == 'AddTransaction') {
      await Navigator.pushAndRemoveUntil(
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

    const quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'AddTransaction') {
        setState(() {
          mode = 'AddTransaction';
        });
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'AddTransaction',
        localizedTitle: 'Add transaction',
        icon: '@drawable/money_icon',
      ),
    ]);

    triggerSplashScreenAnimation(context);
  }

  void setUpQuickActions() {
    const quickActions = QuickActions();
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'AddTransaction',
        localizedTitle: 'Add transaction',
        icon: '@drawable/money_icon',
      ),
      const ShortcutItem(
        type: 'ViewTransactions',
        localizedTitle: 'View transactions',
        icon: '@drawable/history_icon',
      ),
    ]);
    quickActions.initialize((String shortcutType) async {
      if (shortcutType == 'AddTransaction') {
        if (userSignedIn) {
          await Navigator.pushNamed(context, ROUTES.getAddTransactionsRoute);
        }
      }
      if (shortcutType == 'ViewTransactions') {
        if (userSignedIn) {
          context.read<HomeframeCubit>().changeHomeframePage(1);
          await Navigator.pushNamed(context, ROUTES.getHomeframeRoute);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset(
                  'assets/app_icon/aap_icon.png',
                ),
              ),
              // Text(
              //   'Pinext',
              //   style: boldTextStyle.copyWith(
              //     fontSize: 40,
              //     color: customBlackColor,
              //     height: .9,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
