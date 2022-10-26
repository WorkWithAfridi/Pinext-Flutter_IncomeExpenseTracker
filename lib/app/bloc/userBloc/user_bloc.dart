import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/authentication_services.dart';
import 'package:pinext/app/services/date_time_services.dart';

import '../../services/handlers/user_handler.dart';
import '../../shared/widgets/custom_snackbar.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UnauthenticatedUserState()) {
    on<SignInUserEvent>((event, emit) async {
      bool isSignedIn = await AuthenticationServices().signInUser(
          emailAddress: event.emailAddress, password: event.password);
      if (isSignedIn) {
        PinextUserModel user = await UserHandler().getCurrentUser();
        emit(AuthenticatedUserState(
            userId: user.userId,
            username: user.username,
            emailAddress: user.emailAddress,
            netBalance: user.netBalance,
            monthlyBudget: user.monthlyBudget,
            monthlyExpenses: user.monthlyExpenses,
            dailyExpenses: user.dailyExpenses,
            weeklyExpenses: user.weeklyExpenses,
            monthlySavings: user.monthlySavings,
            accountCreatedOn: user.accountCreatedOn,
            currentYear: user.currentYear,
            currentDate: user.currentDate,
            currentMonth: user.currentMonth,
            currentWeekOfTheYear: user.currentWeekOfTheYear));
      }
    });
    on<RefreshUserStateEvent>((event, emit) async {
      PinextUserModel user = await UserHandler().getCurrentUser();

      
      if (user.currentDate == currentDate &&
          user.currentMonth == currentMonth &&
          user.currentYear == currentYear &&
          user.currentWeekOfTheYear == currentWeekOfTheYear) {
        emit(AuthenticatedUserState(
          userId: user.userId,
          username: user.username,
          emailAddress: user.emailAddress,
          netBalance: user.netBalance,
          monthlyBudget: user.monthlyBudget,
          monthlyExpenses: user.monthlyExpenses,
          dailyExpenses: user.dailyExpenses,
          weeklyExpenses: user.weeklyExpenses,
          monthlySavings: user.monthlySavings,
          accountCreatedOn: user.accountCreatedOn,
          currentYear: user.currentYear,
          currentDate: user.currentDate,
          currentMonth: user.currentMonth,
          currentWeekOfTheYear: user.currentWeekOfTheYear,
        ));
        log("Refreshing user");
      } else {
        //updating user datetime
        await UserHandler().resetUserStats(user);
        await UserHandler().updateUserDateTime(user);
        //now refresh user
        user = await UserHandler().getCurrentUser();
        emit(AuthenticatedUserState(
          userId: user.userId,
          username: user.username,
          emailAddress: user.emailAddress,
          netBalance: user.netBalance,
          monthlyBudget: user.monthlyBudget,
          monthlyExpenses: user.monthlyExpenses,
          dailyExpenses: user.dailyExpenses,
          weeklyExpenses: user.weeklyExpenses,
          monthlySavings: user.monthlySavings,
          accountCreatedOn: user.accountCreatedOn,
          currentYear: user.currentYear,
          currentDate: user.currentDate,
          currentMonth: user.currentMonth,
          currentWeekOfTheYear: user.currentWeekOfTheYear,
        ));
      }
    });
    on<SignOutUserEvent>(((event, emit) async {
      bool isSignedOut = await AuthenticationServices().signOutUser();
      if (isSignedOut) {
        emit(UnauthenticatedUserState());
      } else {
        GetCustomSnackbar(
          title: "Snap",
          message:
              "An error occurred while trying to sign you out! Please try closing the app and opening it again.",
          snackbarType: SnackbarType.info,
          context: event.context,
        );
      }
    }));
    on<UnauthenticatedUserEvent>(
      (event, emit) {
        emit(UnauthenticatedUserState());
      },
    );
  }
}
