import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';

import '../../app_data/routing/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void triggerSplashScreenAnimation(BuildContext context) {
    Future.delayed(
      const Duration(seconds: defaultDelayDuration),
    ).then((_) {
      Navigator.pushReplacementNamed(context, ROUTES.getLoginRoute);
    });
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
