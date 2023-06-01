import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/services/authentication_services.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UnauthenticatedUserState()) {
    on<SignInUserEvent>((event, emit) async {
      await SignInUser(event, emit);
    });
    on<RefreshUserStateEvent>((event, emit) async {
      await RereshUserState(emit);
    });
    on<SignOutUserEvent>(
      (event, emit) async {
        await SignOutUser(emit, event);
      },
    );
    on<UnauthenticatedUserEvent>(
      (event, emit) {
        emit(UnauthenticatedUserState());
      },
    );
  }

  Future<void> SignOutUser(Emitter<UserState> emit, SignOutUserEvent event) async {
    final isSignedOut = await AuthenticationServices().signOutUser();
    if (isSignedOut) {
      emit(UnauthenticatedUserState());
      event.context.read<DemoBloc>().add(DisableDemoModeEvent());
    } else {
      GetCustomSnackbar(
        title: 'Snap',
        message: 'An error occurred while trying to sign you out! Please try closing the app and opening it again.',
        snackbarType: SnackbarType.info,
        context: event.context,
      );
    }
  }

  Future<void> RereshUserState(Emitter<UserState> emit) async {
    var user = await UserHandler().getCurrentUser();

    if (user.currentDate == currentDate &&
        user.currentMonth == currentMonth &&
        user.currentYear == currentYear &&
        user.currentWeekOfTheYear == currentWeekOfTheYear) {
      emit(
        AuthenticatedUserState(
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
          monthlyEarnings: user.monthlyEarnings,
          currentWeekOfTheYear: user.currentWeekOfTheYear,
          currencySymbol: user.currencySymbol,
        ),
      );
    } else {
      //updating user datetime
      await UserHandler().resetUserStats(user);
      await UserHandler().updateUserDateTime(user);
      //now refresh user
      user = await UserHandler().getCurrentUser();
      emit(
        AuthenticatedUserState(
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
          monthlyEarnings: user.monthlyEarnings,
          currentWeekOfTheYear: user.currentWeekOfTheYear,
          currencySymbol: user.currencySymbol,
        ),
      );
    }
  }

  Future<void> SignInUser(SignInUserEvent event, Emitter<UserState> emit) async {
    final isSignedIn = await AuthenticationServices().signInUser(emailAddress: event.emailAddress, password: event.password) == 'Success';
    if (isSignedIn) {
      final user = await UserHandler().getCurrentUser();
      emit(
        AuthenticatedUserState(
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
          monthlyEarnings: user.monthlyEarnings,
          currentWeekOfTheYear: user.currentWeekOfTheYear,
          currencySymbol: user.currencySymbol,
        ),
      );
    }
  }
}
