import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/services/authentication_services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void triggerSplashScreenAnimation(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: defaultDelayDuration),
    );
    bool userSignedIn = await AuthenticationServices().isUserSignedIn();
    if (userSignedIn) {
      context.read<UserBloc>().add(RefreshUserStateEvent());
      Navigator.pushNamedAndRemoveUntil(
        context,
        ROUTES.getHomeframeRoute,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        ROUTES.getLoginRoute,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    triggerSplashScreenAnimation(context);
    return Scaffold(
      body: SizedBox(
        height: getHeight(context),
        width: getWidth(context),
        child: Center(
          child: Text(
            "Pinext",
            style: boldTextStyle.copyWith(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
