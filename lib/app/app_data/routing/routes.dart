import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/screens/add_and_view_transaction/add_and_view_transaction.dart';
import 'package:pinext/app/screens/home/homeframe.dart';
import 'package:pinext/app/screens/signin/signin_screen.dart';
import 'package:pinext/app/screens/signup/signup_screen.dart';
import 'package:pinext/app/screens/splash/splash_screen.dart';

class ROUTECONTROLLER {
  static Route<dynamic> routeController(RouteSettings settings) {
    switch (settings.name) {
      case ROUTES.getSplashRoute:
        return CustomTransitionPageRoute(
          childWidget: const SplashScreen(),
        );

      case ROUTES.getLoginRoute:
        return CustomTransitionPageRoute(
          childWidget: const SigninScreen(),
        );
      case ROUTES.getSignupRoute:
        return CustomTransitionPageRoute(
          childWidget: const SignupScreen(),
        );
      case ROUTES.getHomeframeRoute:
        return CustomTransitionPageRoute(
          childWidget: Intro(
            padding: EdgeInsets.zero,
            child: const Homeframe(),
          ),
        );
      case ROUTES.getAddTransactionsRoute:
        return CustomTransitionPageRoute(
          childWidget: AddAndViewTransactionScreen(),
        );
      default:
        log(settings.name.toString());
        throw 'Not a valid route ';
    }
  }
}

class ROUTES {
  static const getSplashRoute = '/';
  static const getLoginRoute = '/login';
  static const getSignupRoute = '/signup';
  static const getHomeframeRoute = '/homeframe';
  static const getAddTransactionsRoute = '/homeframe/add_transactions';
  // static const getAddPinextCardRoute = '/homeframe/add_pinext_card';
}
