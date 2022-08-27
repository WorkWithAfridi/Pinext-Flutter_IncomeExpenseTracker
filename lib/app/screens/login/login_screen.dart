import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/bloc/login_cubit/login_cubit.dart';
import 'package:pinext/app/shared/widgets/socials_button.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/domentions.dart';
import '../../app_data/theme_data/colors.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';

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
    log("Rebuilding");
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          height: getHeight(context),
          width: getWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign In\nTo Account",
                style: boldTextStyle.copyWith(fontSize: 30),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Please sign in with your email and password\nto continue using the app.",
                style: regularTextStyle.copyWith(
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
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginButtonSuccessState) {
                    Navigator.pushReplacementNamed(
                            context, ROUTES.getHomeframeRoute)
                        .then((_) {
                      context.read<LoginCubit>().resetState();
                    });
                  }
                },
                builder: (context, state) {
                  return GetCustomButton(
                    title: "Sign In",
                    titleColor: whiteColor,
                    buttonColor: customBlueColor,
                    isLoading:
                        state is LoginWithEmailAndPasswordButtonLoadingState
                            ? true
                            : false,
                    callBackFunction: () {
                      state is LoginWithAppleIDLoadingState
                          ? () {}
                          : context
                              .read<LoginCubit>()
                              .login(loginTypes: LoginTypes.emailAndPassword);
                    },
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Or sign in with socials",
                style: regularTextStyle.copyWith(
                  fontSize: 14,
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              SocialsButton(),
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
                        style: regularTextStyle.copyWith(
                          fontSize: 14,
                          color: customBlackColor.withOpacity(.6),
                        ),
                      ),
                      TextSpan(
                        text: "Sign up",
                        style: boldTextStyle.copyWith(
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
