import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/handlers/user_handler.dart';
import 'package:pinext/app/models/pinext_user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UnauthenticatedUserState()) {
    on<SignInUserEvent>((event, emit) {});
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
  }
}
