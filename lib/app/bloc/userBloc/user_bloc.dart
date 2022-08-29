import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/models/pinext_user_model.dart';
import 'package:pinext/app/services/authentication_services.dart';

import '../../services/handlers/user_handler.dart';

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
        ));
      }
    });
    on<RefreshUserStateEvent>((event, emit) async {
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
      ));
    });
    on<SignOutUserEvent>(((event, emit) {
      bool isSignedOut = AuthenticationServices().signOutUser();
      if (isSignedOut) {
        emit(UnauthenticatedUserState());
      } else {
        // error signing out
      }
    }));
  }
}
