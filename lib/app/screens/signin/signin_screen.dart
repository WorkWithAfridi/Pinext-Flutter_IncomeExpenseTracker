import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/bloc/signin_cubit/login_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/socials_button.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/domentions.dart';
import '../../app_data/theme_data/colors.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const SigninScreenView(),
    );
  }
}

class SigninScreenView extends StatefulWidget {
  const SigninScreenView({Key? key}) : super(key: key);

  @override
  State<SigninScreenView> createState() => _SigninScreenViewState();
}

class _SigninScreenViewState extends State<SigninScreenView> {
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

  final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
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
                CustomTextFormField(
                  controller: emailController,
                  hintTitle: "Email address",
                  onChanged: (String value) {},
                  validator: (value) {
                    return InputValidation(value.toString())
                        .isCorrectEmailAddress();
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintTitle: "Password",
                  isPassword: true,
                  onChanged: (String value) {},
                  validator: (value) {
                    return InputValidation(value).isNotEmpty();
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocListener<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is AuthenticatedUserState) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        ROUTES.getHomeframeRoute,
                        (route) => false,
                      );
                    }
                  },
                  child: BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccessState) {
                        context.read<UserBloc>().add(RefreshUserStateEvent());
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
                        isLoading: state
                            is LoginWithEmailAndPasswordButtonLoadingState,
                        callBackFunction: () {
                          if (_formKey.currentState!.validate()) {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              context
                                  .read<LoginCubit>()
                                  .loginWithEmailAndPassword(
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
                          }
                        },
                      );
                    },
                  ),
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
      ),
    );
  }
}
