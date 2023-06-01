import 'dart:io';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/signin_cubit/login_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/services/authentication_services.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/horizontal_bar.dart';
import 'package:pinext/country_data/country_data.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const SigninScreenView(),
    );
  }
}

class SigninScreenView extends StatefulWidget {
  const SigninScreenView({super.key});

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
    context.read<RegionCubit>().selectRegion(CountryHandler().countryList.where((element) => element.code == 'BD').first);
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
      appBar: AppBar(
        title: Text(
          'PINEXT',
          style: regularTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign In\nTo PINEXT',
                  style: boldTextStyle.copyWith(fontSize: 30),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Please sign in with your email and password\nto continue using the app.',
                  style: regularTextStyle.copyWith(
                    fontSize: 14,
                    color: customBlackColor.withOpacity(.6),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: emailController,
                  hintTitle: 'Email address',
                  onChanged: (String value) {},
                  validator: (value) {
                    return InputValidation(value.toString()).isCorrectEmailAddress();
                  },
                  suffixButtonAction: () {},
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintTitle: 'Password',
                  isPassword: true,
                  onChanged: (String value) {},
                  validator: (String value) {
                    return InputValidation(value).isNotEmpty();
                  },
                  suffixButtonAction: () {},
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      final resetEmailController = TextEditingController();
                      final emailFormKey = GlobalKey<FormState>();
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: Text(
                              'Find your Pinext account',
                              style: boldTextStyle.copyWith(
                                fontSize: 16,
                                color: customBlackColor.withOpacity(.85),
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text(
                                    "Enter the email associated with your account and we'll sent you a reset link. :)",
                                    style: regularTextStyle.copyWith(
                                      color: customBlackColor.withOpacity(.5),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Form(
                                    key: emailFormKey,
                                    child: CustomTextFormField(
                                      controller: resetEmailController,
                                      hintTitle: 'Email',
                                      onChanged: (value) {},
                                      validator: (String value) {
                                        return InputValidation(value).isCorrectEmailAddress();
                                      },
                                      suffixButtonAction: () {},
                                    ),
                                  )
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(defaultBorder),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: boldTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(
                                      .8,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Reset password'),
                                onPressed: () async {
                                  if (emailFormKey.currentState!.validate()) {
                                    if (resetEmailController.text.isNotEmpty) {
                                      Navigator.pop(dialogContext);
                                      await AuthenticationServices()
                                          .resetPassword(
                                        email: resetEmailController.text,
                                      )
                                          .then(
                                        (value) {
                                          if (value == 'Success') {
                                            GetCustomSnackbar(
                                              title: 'We sent you a code',
                                              message: 'Please check your email to reset your password.',
                                              snackbarType: SnackbarType.info,
                                              context: context,
                                            );
                                          } else {
                                            GetCustomSnackbar(
                                              title: 'Snap',
                                              message: value,
                                              snackbarType: SnackbarType.info,
                                              context: context,
                                            );
                                          }
                                        },
                                      );
                                    } else {
                                      GetCustomSnackbar(
                                        title: 'Snap',
                                        message: 'We need your email in order to reset your password!',
                                        snackbarType: SnackbarType.info,
                                        context: context,
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                            actionsPadding: dialogButtonPadding,
                          );
                        },
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: boldTextStyle.copyWith(
                        fontSize: 14,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
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
                        context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
                      }
                      if (state is LoginErrorState) {
                        GetCustomSnackbar(
                          title: 'Snap',
                          message: state.errorMessage,
                          snackbarType: SnackbarType.error,
                          context: context,
                        );
                        context.read<LoginCubit>().resetState();
                      }
                    },
                    builder: (context, state) {
                      return GetCustomButton(
                        title: 'Sign In',
                        titleColor: whiteColor,
                        buttonColor: primaryColor,
                        isLoading: state is LoginWithEmailAndPasswordButtonLoadingState,
                        callBackFunction: () {
                          if (_formKey.currentState!.validate()) {
                            if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                              context.read<LoginCubit>().loginWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                            } else {
                              GetCustomSnackbar(
                                title: 'Snap',
                                message: 'We need your email and password in order to sign you in!',
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
                  height: 8,
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
                          text: 'Sign up using email.',
                          style: boldTextStyle.copyWith(
                            fontSize: 14,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (Platform.isAndroid || Platform.isIOS)
                  Column(
                    children: [
                      const SizedBox(
                        height: 22,
                      ),
                      Row(
                        children: [
                          Text(
                            'Or sign in using socials',
                            style: boldTextStyle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const GetHorizontalBar()
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 3,
                        shadowColor: Colors.black.withOpacity(.5),
                        child: BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            return GetCustomButton(
                              isLoading: state is LoginWithGoogleButtonLoadingState,
                              icon: AntIcons.googleCircleFilled,
                              title: 'Sign in with Google',
                              titleColor: whiteColor,
                              buttonColor: customBlackColor,
                              callBackFunction: () {
                                context.read<LoginCubit>().loginWithGoogle();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
