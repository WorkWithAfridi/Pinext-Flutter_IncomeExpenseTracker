// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'homeframe_page_cubit.dart';

@immutable
abstract class HomeframePageState {
  int selectedIndex;
  PageController pageController;
  HomeframePageState(
      {required this.selectedIndex, required this.pageController});
}

class PageState extends HomeframePageState {
  PageState({
    required super.selectedIndex,
    required super.pageController,
  });
}
