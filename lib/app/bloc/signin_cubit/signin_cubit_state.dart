part of 'signin_cubit_cubit.dart';

abstract class SigninState extends Equatable {
  const SigninState(this.pageController);
  final PageController pageController;

  @override
  List<Object> get props => [];
}

class SigninDefaultState extends SigninState {
  const SigninDefaultState(super.pageController);
}
