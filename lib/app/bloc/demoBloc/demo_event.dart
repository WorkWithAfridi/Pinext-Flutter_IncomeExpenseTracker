part of 'demo_bloc.dart';

abstract class DemoEvent extends Equatable {
  const DemoEvent();

  @override
  List<Object> get props => [];
}

class EnableDemoModeEvent extends DemoEvent {}
class DisableDemoModeEvent extends DemoEvent {}
