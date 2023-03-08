import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class GetCustomButton extends StatelessWidget {
  GetCustomButton({
    super.key,
    required this.title,
    required this.titleColor,
    required this.buttonColor,
    this.iconColor = whiteColor,
    this.icon,
    this.isLoading = false,
    required this.callBackFunction,
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
              const ButtonLoadingAnimation()
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
  const ButtonLoadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 20,
      child: LottieBuilder.asset(
        'assets/animations/loading_animation.json',
      ),
    );
  }
}
