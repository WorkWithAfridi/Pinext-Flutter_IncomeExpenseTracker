import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/colors.dart';

import '../../app_data/domentions.dart';

class GetCustomButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color buttonColor;
  final IconData? icon;
  final Color iconColor;
  const GetCustomButton({
    Key? key,
    required this.title,
    required this.titleColor,
    required this.buttonColor,
    this.iconColor = whiteColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: getWidth(context),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(defaultBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
