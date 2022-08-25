import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/domentions.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';

class GetCustomButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color buttonColor;
  final IconData? icon;
  final Color iconColor;
  late bool isLoading;
  late Function callBackFunction;

  GetCustomButton({
    Key? key,
    required this.title,
    required this.titleColor,
    required this.buttonColor,
    this.iconColor = whiteColor,
    this.icon,
    this.isLoading = false,
    required this.callBackFunction,
  }) : super(key: key);

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
            isLoading
                ? const ButtonLoadingAnimation()
                : Row(
                    children: [
                      icon != null
                          ? Row(
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
                          : const SizedBox.shrink(),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 20,
      child: LottieBuilder.asset(
        "assets/animations/loading_animation.json",
      ),
    );
  }
}
