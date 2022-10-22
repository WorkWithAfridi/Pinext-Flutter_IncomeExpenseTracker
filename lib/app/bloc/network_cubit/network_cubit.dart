import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit()
      : super(
          NetworkDefault(),
        );

  updateNetworkState(String state) {
    switch (state) {
      case "Mobile":
        emit(NetworkConnected());
        break;
      case "Wifi":
        emit(NetworkConnected());
        break;
      case "None":
        log("Emmiting disconnected state!");
        emit(NetworkDisconnected());
        break;
      default:
        emit(NetworkDisconnected());
        break;
    }
  }
}
