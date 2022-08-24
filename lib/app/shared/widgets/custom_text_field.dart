import 'package:flutter/material.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/theme_data/colors.dart';

class GetCustomTextField extends StatelessWidget {
  final String hintTitle;
  final TextEditingController controller;
  final bool isPassword;
  const GetCustomTextField({
    Key? key,
    required this.controller,
    required this.hintTitle,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 1,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintTitle,
        hintStyle: TextStyle(
          color: customBlackColor.withOpacity(
            .5,
          ),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderSide: Divider.createBorderSide(
            context,
            color: cyanColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(
            context,
            color: customBlueColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(
            context,
            color: customBlackColor.withOpacity(.2),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        fillColor: greyColor,
        filled: true,
      ),
      obscureText: isPassword,
      obscuringCharacter: "*",
    );
  }
}
