import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/theme_data/colors.dart';

class GetCustomTextField extends StatelessWidget {
  final String hintTitle;
  final TextEditingController controller;
  final bool isPassword;
  int numberOfLines;
  TextInputType textInputType;
  GetCustomTextField({
    Key? key,
    required this.controller,
    required this.hintTitle,
    this.numberOfLines = 1,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
    required this.onChanged,
  }) : super(key: key);

  Function onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: regularTextStyle,
      maxLines: numberOfLines,
      keyboardType: textInputType,
      textInputAction: TextInputAction.next,
      onChanged: ((value) {
        onChanged(value);
      }),
      decoration: InputDecoration(
        hintText: hintTitle,
        hintStyle: regularTextStyle.copyWith(
          color: customBlackColor.withOpacity(
            .5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
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
