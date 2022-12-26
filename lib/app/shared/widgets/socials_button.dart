import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinext/app/bloc/signin_cubit/login_cubit.dart';

import '../../app_data/theme_data/colors.dart';

class SocialsButton extends StatelessWidget {
  SocialsButton({Key? key}) : super(key: key);
  List socialButtons = [
    // "appleId",
    // "facebook",
    "google",
  ];
  var radius = 50.00;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: socialButtons.length,
        itemBuilder: (context, index) {
          // "appleId",
          // "facebook",
          // "google",
          String social = socialButtons[index];
          IconData icon;
          Color backgroundColor;
          if (social == "appleId") {
            icon = Icons.apple;
            backgroundColor = Colors.black;
          } else if (social == "facebook") {
            icon = Icons.facebook;
            backgroundColor = Colors.blue[900]!;
          } else if (social == "google") {
            icon = FontAwesomeIcons.google;
            backgroundColor = Colors.orange[900]!;
          } else {
            icon = Icons.help;
            backgroundColor = Colors.pink;
          }
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () async {
                if (social == "google") {
                  context.read<LoginCubit>().loginWithGoogle();
                }
              },
              child: Container(
                height: radius,
                width: radius,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: greyColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
