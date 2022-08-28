import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/bloc/login_cubit/login_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
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

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({Key? key}) : super(key: key);

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: emailController,
                hintTitle: "Username or email",
              ),
              const SizedBox(
                height: 8,
              ),
              GetCustomTextField(
                controller: passwordController,
                hintTitle: "Password",
                isPassword: true,
              ),
              const SizedBox(
                height: 16,
              ),
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ROUTES.getHomeframeRoute,
                      (route) => false,
                    );
                  }
                  if (state is LoginErrorState) {
                    GetCustomSnackbar(
                      title: "Snap",
                      message: state.errorMessage,
                      snackbarType: SnackbarType.error,
                      context: context,
                    );
                    context.read<LoginCubit>().resetState();
                  }
                },
                builder: (context, state) {
                  return GetCustomButton(
                    title: "Sign In",
                    titleColor: whiteColor,
                    buttonColor: customBlueColor,
                    isLoading:
                        state is LoginWithEmailAndPasswordButtonLoadingState,
                    callBackFunction: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        context.read<LoginCubit>().loginWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                      } else {
                        GetCustomSnackbar(
                          title: "Snap",
                          message:
                              "We need your email and password in order to sign you in!",
                          snackbarType: SnackbarType.info,
                          context: context,
                        );
                      }
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
