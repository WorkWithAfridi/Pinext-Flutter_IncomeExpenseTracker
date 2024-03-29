import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinext/app/bloc/signin_cubit/login_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';

class SocialsButton extends StatelessWidget {
  SocialsButton({super.key});
  List socialButtons = [
    // "appleId",
    // "facebook",
    'google',
  ];
  double radius = 50;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: socialButtons.length,
              itemBuilder: (context, index) {
                // "appleId",
                // "facebook",
                // "google",
                final social = socialButtons[index] as String;
                IconData icon;
                Color backgroundColor;
                if (social == 'appleId') {
                  icon = Icons.apple;
                  backgroundColor = Colors.black;
                } else if (social == 'facebook') {
                  icon = Icons.facebook;
                  backgroundColor = Colors.blue[900]!;
                } else if (social == 'google') {
                  icon = FontAwesomeIcons.google;
                  backgroundColor = Colors.orange[900]!;
                } else {
                  icon = Icons.help;
                  backgroundColor = Colors.pink;
                }
                return GetCustomButton(
                  title: 'Signin with Google',
                  titleColor: Colors.white,
                  isLoading: state is LoginWithGoogleButtonLoadingState,
                  buttonColor: Colors.black,
                  callBackFunction: () {
                    if (social == 'google') {
                      context.read<LoginCubit>().loginWithGoogle();
                    }
                  },
                  icon: icon,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
