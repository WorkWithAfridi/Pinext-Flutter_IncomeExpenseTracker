import 'package:bloc/bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';

part 'login_state.dart';

enum LoginTypes {
  emailAndPassword,
  appleId,
  facebook,
  google,
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginDefaultState());

  login({required LoginTypes loginTypes}) {
    switch (loginTypes) {
      case LoginTypes.emailAndPassword:
        _loginWithEmailAndPassword();
        break;
      case LoginTypes.appleId:
        _loginWithAppleId();
        break;
      case LoginTypes.facebook:
        // TODO: Handle this case.
        break;
      case LoginTypes.google:
        // TODO: Handle this case.
        break;
    }
  }

  resetState() {
    emit(LoginDefaultState());
  }

  _loginWithEmailAndPassword() {
    emit(LoginWithEmailAndPasswordButtonLoadingState());
    Future.delayed(
      const Duration(
        seconds: defaultDelayDuration,
      ),
    ).then((value) {
      emit(LoginButtonSuccessState());
    });
  }

  _loginWithAppleId() {
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
