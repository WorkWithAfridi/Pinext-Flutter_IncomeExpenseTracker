import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/bloc/network_cubit/network_cubit.dart';

class NetworkHandler {
  NetworkHandler._internal();
  static final NetworkHandler _networkHandler = NetworkHandler._internal();
  factory NetworkHandler() => _networkHandler;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectiitySubscription;

  Future checkConnectivity(BuildContext context) async {
    _connectiitySubscription = _connectivity.onConnectivityChanged.listen(((event) {
      _updateConnectionStatus(event, context);
    }));
    ConnectivityResult? connectivityResult;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
    } on PlatformException catch (err) {
      log(err.toString());
    }
    return _updateConnectionStatus(connectivityResult, context);
  }

  _updateConnectionStatus(ConnectivityResult? connectivityResult, BuildContext context) {
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        log("On Wifi");
        context.read<NetworkCubit>().updateNetworkState("Wifi");
        break;
      case ConnectivityResult.mobile:
        log("On Mobile");
        context.read<NetworkCubit>().updateNetworkState("Mobile");
        break;
      case ConnectivityResult.none:
        log("None");
        context.read<NetworkCubit>().updateNetworkState("None");
        break;
      default:
        log("None");
        context.read<NetworkCubit>().updateNetworkState("None");
        break;
    }
  }
}
