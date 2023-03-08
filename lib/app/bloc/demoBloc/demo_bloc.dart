import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'demo_event.dart';
part 'demo_state.dart';

class DemoBloc extends Bloc<DemoEvent, DemoState> {
  DemoBloc() : super(DemoDisabledState()) {
    on<EnableDemoModeEvent>(
      (event, emit) {
        emit(DemoEnabledState());
      },
    );
    on<DisableDemoModeEvent>((event, emit) {
      emit(DemoDisabledState());
    });
  }
}
