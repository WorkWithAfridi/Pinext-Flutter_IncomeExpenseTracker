import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'homeframe_page_state.dart';

class HomeframeCubit extends Cubit<HomeframeState> {
  HomeframeCubit()
      : super(
          HoemframeInitialState(
            selectedIndex: 0,
            pageController: PageController(initialPage: 0),
          ),
        );

  changeHomeframePage(int index) {
    state.pageController.jumpToPage(index);
    emit(HoemframeInitialState(
      selectedIndex: index,
      pageController: state.pageController,
    ));
  }
}
