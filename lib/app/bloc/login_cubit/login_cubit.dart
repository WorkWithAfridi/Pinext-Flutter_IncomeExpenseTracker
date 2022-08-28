import 'package:bloc/bloc.dart';

import '../../app_data/app_constants/constants.dart';
import '../../services/authentication_services.dart';

part 'login_state.dart';

enum LoginTypes {
  emailAndPassword,
  appleId,
  facebook,
  google,
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginDefaultState());

  resetState() {
    emit(LoginDefaultState());
  }

  loginWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(
      LoginWithEmailAndPasswordButtonLoadingState(),
    );
    await Future.delayed(
      const Duration(
        seconds: defaultDelayDuration,
      ),
    );
    String response = await AuthenticationServices()
        .signInUser(emailAddress: email, password: password);
    if (response == "Success") {
      emit(
        LoginSuccessState(),
      );
    } else {
      emit(
        LoginErrorState(
          errorMessage: response,
        ),
      );
    }
  }
}
