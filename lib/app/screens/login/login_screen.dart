import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/bloc/login_cubit/login_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/theme_data/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginScreenView(),
    );
  }
}

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginButtonSuccessState) {
          Navigator.pushReplacementNamed(context, ROUTES.getHomeframeRoute)
              .then((_) {
            context.read<LoginCubit>().resetState();
          });
        }
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          height: getHeight(context),
          width: getWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sign In\nTo Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: customBlackColor,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Please sign in with your email and password\nto continue using the app.",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GetCustomTextField(
                controller: TextEditingController(),
                hintTitle: "Username or email",
              ),
              const SizedBox(
                height: 8,
              ),
              GetCustomTextField(
                controller: TextEditingController(),
                hintTitle: "Password",
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return GetCustomButton(
                    title: "Sign In",
                    titleColor: whiteColor,
                    buttonColor: customBlueColor,
                    isLoading: state is LoginButtonLoadingState ? true : false,
                    callBackFunction: () {
                      state is LoginWithAppleIDLoadingState
                          ? () {}
                          : context.read<LoginCubit>().onLoginButtonClick();
                    },
                  );
                },
              ),
              const SizedBox(
                height: 8,
              ),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return GetCustomButton(
                    title: "Sign in with Apple ID",
                    titleColor: whiteColor,
                    buttonColor: Colors.black,
                    icon: Icons.apple,
                    isLoading:
                        state is LoginWithAppleIDLoadingState ? true : false,
                    callBackFunction: () {
                      state is LoginButtonLoadingState
                          ? () {}
                          : context
                              .read<LoginCubit>()
                              .onLoginWithAppleIdButtonClick();
                    },
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ROUTES.getSignupRoute);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: customBlackColor.withOpacity(.6),
                        ),
                      ),
                      const TextSpan(
                        text: "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: customBlueColor,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
