// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_cubit.dart';

abstract class LoginState {}

class LoginDefaultState extends LoginState {}

class LoginButtonLoadingState extends LoginState {}

class LoginButtonSuccessState extends LoginState {}

class LoginWithAppleIDLoadingState extends LoginState {}
