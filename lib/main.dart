import 'package:flutter/material.dart';

import 'app/routing/routes.dart';

void main(List<String> args) {
  runApp(const Pinext());
}

class Pinext extends StatelessWidget {
  const Pinext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: ROUTECONTROLLER.routeController,
      initialRoute: ROUTES.getSplashRoute,
    );
  }
}
