import 'package:bloc/bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/services/authentication_services.dart';

part 'login_state.dart';

enum LoginTypes {
  emailAndPassword,
  appleId,
  facebook,
  google,
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginDefaultState());

  void resetState() {
    emit(LoginDefaultState());
  }

  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {
    emit(
      LoginWithEmailAndPasswordButtonLoadingState(),
    );
    await Future.delayed(
      const Duration(
        seconds: defaultDelayDuration,
      ),
    );
    final response = await AuthenticationServices().signInUser(emailAddress: email, password: password);
    if (response == 'Success') {
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

  Future<void> loginWithGoogle() async {
    emit(LoginWithGoogleButtonLoadingState());
    await Future.delayed(
      const Duration(
        seconds: defaultDelayDuration,
      ),
    );
    final response = await AuthenticationServices().googleSignin();
    if (response == 'Success') {
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
