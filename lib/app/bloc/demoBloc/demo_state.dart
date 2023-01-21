part of 'demo_bloc.dart';

abstract class DemoState extends Equatable {
  const DemoState();

  @override
  List<Object> get props => [];
}

class DemoDefaultState extends DemoState {}

class DemoEnabledState extends DemoState {}

class DemoDisabledState extends DemoState {}
