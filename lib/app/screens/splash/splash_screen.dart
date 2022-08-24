import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_dimentions/domentions.dart';

import '../../app_data/routing/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void triggerSplashScreenAnimation(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
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
        child: const Center(
          child: Text("Pinext"),
        ),
      ),
    );
  }
}
