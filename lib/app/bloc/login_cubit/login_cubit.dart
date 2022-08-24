import 'package:bloc/bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginDefaultState());

  onLoginButtonClick() {
    emit(LoginButtonLoadingState());
    Future.delayed(
      const Duration(
        seconds: defaultDelayDuration,
      ),
    ).then((value) {
      emit(LoginButtonSuccessState());
    });
  }

  resetState() {
    emit(LoginDefaultState());
  }

  onLoginWithAppleIdButtonClick() {
    emit(LoginWithAppleIDLoadingState());
    Future.delayed(
      const Duration(
        seconds: defaultDelayDuration,
      ),
    ).then((value) {
      emit(LoginDefaultState());
    });
  }
}
