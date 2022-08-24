import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/theme.dart';

import 'app/routing/routes.dart';

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
