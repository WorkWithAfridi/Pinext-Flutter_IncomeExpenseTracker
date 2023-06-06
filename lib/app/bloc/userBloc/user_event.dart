// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignInUserEvent extends UserEvent {
  String emailAddress;
  String password;
  SignInUserEvent({
    required this.emailAddress,
    required this.password,
  });
  @override
  List<Object> get props => [
        emailAddress,
        password,
      ];
}

class RefreshUserStateEvent extends UserEvent {
  BuildContext context;
  RefreshUserStateEvent({
    required this.context,
  });
}

class SignOutUserEvent extends UserEvent {
  BuildContext context;
  SignOutUserEvent({
    required this.context,
  });
}

class UnauthenticatedUserEvent extends UserEvent {}

class ResetUserDataEvent extends UserEvent {
  AuthenticatedUserState currentState;
  BuildContext context;
  ResetUserDataEvent({
    required this.currentState,
    required this.context,
  });
}

class DeleteUserEvent extends UserEvent {
  AuthenticatedUserState currentState;
  BuildContext context;
  DeleteUserEvent({
    required this.currentState,
    required this.context,
  });
}
