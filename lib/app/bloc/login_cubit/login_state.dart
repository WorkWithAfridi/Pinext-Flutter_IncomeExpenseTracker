// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_cubit.dart';

abstract class LoginState {}

class LoginDefaultState extends LoginState {}

class LoginWithEmailAndPasswordButtonLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginErrorState extends LoginState {
  String errorMessage;
  LoginErrorState({
    required this.errorMessage,
  });
}
