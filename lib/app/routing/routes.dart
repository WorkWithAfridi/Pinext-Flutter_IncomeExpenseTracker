import 'dart:developer';

import 'package:flutter/material.dart';

import '../screens/login/login_screen.dart';
import '../screens/splash/splash_screen.dart';

class ROUTECONTROLLER {
  static Route<dynamic> routeController(RouteSettings settings) {
    switch (settings.name) {
      case ROUTES.getSplashRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case ROUTES.getLoginRoute:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      default:
        log(settings.name.toString());
        throw ("Not a valid route ");
    }
  }
}

class ROUTES {
  static const getSplashRoute = '/';
  static const getLoginRoute = '/login';
}
