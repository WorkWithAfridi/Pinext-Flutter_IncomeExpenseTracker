import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/screens/splash/splash_screen.dart';

import '../../bloc/network_cubit/network_cubit.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "ERROR",
      //     style: boldTextStyle.copyWith(
      //         // color: Colors.white,
      //         ),
      //   ),
      //   backgroundColor: whiteColor,
      // ),
      backgroundColor: whiteColor,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: BlocListener<NetworkCubit, NetworkState>(
          listener: (context, state) {
            if (state is NetworkConnected) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
                (route) => false,
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ERROR",
                style: boldTextStyle.copyWith(
                    // color: Colors.white,
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: LottieBuilder.asset(
                  'assets/animations/404.json',
                ),
              ),
              Text(
                "Snap...",
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Looks like you dont have an active internet connection! Please ensure connectiity and try again later.",
                style: regularTextStyle,
                textAlign: TextAlign.center,
              ),
              // const SizedBox(
              //   height: 15,
              // ),
              // Text(
              //   "Please ensure an active internet connection and try again later. :D",
              //   style: regularTextStyle,
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(
                height: 15,
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.restart_alt,
                  size: 25,
                ),
              ),
              // CustomButton(
              //   title: "Try again",
              //   callBackFunction: () {
              //     networkController.checkConnectivity();
              //     if (networkController.connectionStatus != "NoConnection") {
              //       Get.offAllNamed(ROUTES.getSplashScreenRoute);
              //     }
              //   },
              //   isLoading: false,
              // ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
