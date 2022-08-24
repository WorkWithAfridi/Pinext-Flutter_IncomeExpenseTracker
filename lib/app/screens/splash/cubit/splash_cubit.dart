import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/routing/routes.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitialState());
  triggerSplashScreen(BuildContext context) async {
    Future.delayed(
      const Duration(seconds: 2),
    ).then((_) {
      Navigator.pushReplacementNamed(context, ROUTES.getLoginRoute);
    });
  }
}
