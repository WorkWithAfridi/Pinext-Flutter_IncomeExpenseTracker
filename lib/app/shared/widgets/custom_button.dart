import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class GetCustomButton extends StatelessWidget {
  GetCustomButton({
    required this.title, required this.titleColor, required this.buttonColor, required this.callBackFunction, super.key,
    this.iconColor = whiteColor,
    this.icon,
    this.isLoading = false,
  });
  final String title;
  final Color titleColor;
  final Color buttonColor;
  final IconData? icon;
  final Color iconColor;
  late bool isLoading;
  late Function callBackFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBackFunction();
      },
      child: Container(
        height: 50,
        width: getWidth(context),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(defaultBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              ButtonLoadingAnimation()
            else
              Row(
                children: [
                  if (icon != null)
                    Row(
                      children: [
                        Icon(
                          icon,
                          color: iconColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  Text(
                    title,
                    style: boldTextStyle.copyWith(
                      fontSize: 14,
                      color: titleColor,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class ButtonLoadingAnimation extends StatelessWidget {
  ButtonLoadingAnimation({
    super.key,
    this.loadingColor = Colors.white,
  });

  Color loadingColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        color: loadingColor,
        strokeWidth: 2.5,
      ),

      // LottieBuilder.asset(
      //   'assets/animations/loading_animation.json',
      // ),
    );
  }
}
