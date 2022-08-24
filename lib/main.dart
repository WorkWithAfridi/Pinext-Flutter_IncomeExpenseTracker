import 'package:flutter/material.dart';

import 'app/app_data/routing/routes.dart';
import 'app/app_data/theme_data/theme.dart';

void main(List<String> args) {
  runApp(const Pinext());
}

class Pinext extends StatelessWidget {
  const Pinext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: ROUTECONTROLLER.routeController,
      initialRoute: ROUTES.getSplashRoute,
      theme: PinextTheme.lightTheme,
    );
  }
}
