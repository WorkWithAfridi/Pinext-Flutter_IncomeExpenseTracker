import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/select_region_page.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';

class UserRegistrationPage extends StatelessWidget {
  UserRegistrationPage({
    super.key,
    required this.userNameController,
    required this.emailController,
    required this.passwordController,
    required this.pageController,
  });
  TextEditingController userNameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  PageController pageController;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        width: getWidth(context),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: boldTextStyle.copyWith(fontSize: 30),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Please provide the following data\nto register a new account.',
                style: regularTextStyle.copyWith(
                  fontSize: 14,
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextFormField(
                controller: userNameController,
                hintTitle: 'Enter username...',
                onChanged: (String value) {},
                validator: (value) {
                  return InputValidation(value.toString()).isCorrectName();
                },
                suffixButtonAction: () {},
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextFormField(
                controller: emailController,
                hintTitle: 'Email address...',
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
                validator: (value) {
                  return InputValidation(value.toString()).isNotEmpty();
                },
                suffixButtonAction: () {},
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CustomTransitionPageRoute(
                      childWidget: SelectRegionScreen(
                        isUpdateUserRegion: false,
                      ),
                    ),
                  );
                },
                child: BlocBuilder<RegionCubit, RegionState>(
                  builder: (context, state) {
                    return Container(
                      height: 50,
                      width: getWidth(context),
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(defaultBorder),
                        border: Border.all(
                          color: customBlackColor.withOpacity(.1),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                      ),
                      child: state.isLoading
                          ? Center(
                              child: ButtonLoadingAnimation(
                                loadingColor: customBlackColor,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Region ',
                                  style: regularTextStyle.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  // UserHandler().currentUser.currencySymbol,
                                  state.countryData.name,
                                  style: regularTextStyle.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GetCustomButton(
                title: 'Next',
                titleColor: whiteColor,
                buttonColor: primaryColor,
                callBackFunction: () {
                  if (_formKey.currentState!.validate()) {
                    if (userNameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                      pageController.jumpToPage(
                        1,
                      );
                    } else {
                      GetCustomSnackbar(
                        title: '....',
                        message: 'You need to fill up the form to proceed to the next step!',
                        snackbarType: SnackbarType.info,
                        context: context,
                      );
                    }
                  }
                },
              ),
              // const SizedBox(
              //   height: 12,
              // ),
              // Text(
              //   "Or sign up using socials",
              //   style: regularTextStyle.copyWith(
              //     fontSize: 14,
              //     color: customBlackColor.withOpacity(.6),
              //   ),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // SocialsButton(),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: regularTextStyle.copyWith(
                          fontSize: 14,
                          color: customBlackColor.withOpacity(.6),
                        ),
                      ),
                      TextSpan(
                        text: 'Sign in',
                        style: boldTextStyle.copyWith(
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
