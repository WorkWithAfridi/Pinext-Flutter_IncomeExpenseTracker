// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'homeframe_navbar_cubit.dart';

@immutable
abstract class HomeframeNavbarState {
  int selectedIndex;
  HomeframeNavbarState({
    required this.selectedIndex,
  });
}

class NavbarState extends HomeframeNavbarState {
  NavbarState({required super.selectedIndex});
}
