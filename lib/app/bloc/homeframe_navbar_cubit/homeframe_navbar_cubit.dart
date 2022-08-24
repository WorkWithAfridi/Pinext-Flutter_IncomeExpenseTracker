import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'homeframe_navbar_state.dart';

class HomeframeNavbarCubit extends Cubit<HomeframeNavbarState> {
  HomeframeNavbarCubit()
      : super(
          NavbarState(selectedIndex: 0),
        );

  changeNavbarState(int index) {
    emit(NavbarState(
      selectedIndex: index,
    ));
  }
}
