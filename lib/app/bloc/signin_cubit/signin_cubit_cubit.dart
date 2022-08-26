import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'signin_cubit_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit()
      : super(
          SigninDefaultState(
            PageController(initialPage: 0),
          ),
        );
}
