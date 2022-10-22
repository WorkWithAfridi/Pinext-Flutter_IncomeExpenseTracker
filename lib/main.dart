import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinext/app/bloc/cards_and_balances_cubit/cards_and_balances_cubit.dart';
import 'package:pinext/app/bloc/network_cubit/network_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';

import 'app/app_data/routing/routes.dart';
import 'app/app_data/theme_data/theme.dart';
import 'app/bloc/signup_cubit/signin_cubit_cubit.dart';
import 'app/services/handlers/network_handler.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const Pinext());
}

class Pinext extends StatelessWidget {
  const Pinext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SigninCubit(),
        ),
        BlocProvider(
          create: (context) => CardsAndBalancesCubit(),
        ),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(
          create: (context) => NetworkCubit(),
        ),
      ],
      child: const MaterialAppWidget(),
    );
  }
}

class MaterialAppWidget extends StatelessWidget {
  const MaterialAppWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkHandler().checkConnectivity(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: ROUTECONTROLLER.routeController,
      initialRoute: ROUTES.getSplashRoute,
      theme: PinextTheme.lightTheme,
    );
  }
}
