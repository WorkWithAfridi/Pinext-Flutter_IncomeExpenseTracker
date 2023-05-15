import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/theme.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/archive_cubit/user_statistics_cubit/user_statistics_cubit.dart';
import 'package:pinext/app/bloc/bloc_observer/bloc_observer.dart';
import 'package:pinext/app/bloc/cards_and_balances_cubit/cards_and_balances_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/signup_cubit/signin_cubit_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final analytics = FirebaseAnalytics.instance;

  Bloc.observer = PinextObserver();

  const initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

  const initializationSettingsIOS = DarwinInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const Pinext());
}

class Pinext extends StatelessWidget {
  const Pinext({super.key});

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
          create: (context) => DemoBloc(),
        ),
        BlocProvider(
          create: (context) => UserStatisticsCubit(),
        ),
        BlocProvider(
          create: (context) => ArchiveCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: ROUTECONTROLLER.routeController,
        initialRoute: ROUTES.getSplashRoute,
        theme: PinextTheme.lightTheme,
      ),
    );
  }
}
