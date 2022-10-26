import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/theme_data/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintTitle;
  final TextEditingController controller;
  final bool isPassword;
  int numberOfLines;
  TextInputType textInputType;

  CustomTextFormField(
      {Key? key,
      required this.controller,
      required this.hintTitle,
      this.numberOfLines = 1,
      this.isPassword = false,
      this.textInputType = TextInputType.text,
      required this.onChanged,
      required this.validator,
      this.showClearSuffix = false,
      required this.suffixButtonAction,
      this.isEnabled = true,
      this.textInputAction = TextInputAction.next,})
      : super(key: key);

  Function onChanged;
  Function validator;
  Function suffixButtonAction;
  bool showClearSuffix;
  bool isEnabled;

  TextInputAction textInputAction;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shoWPassword = widget.isPassword;
  }

  late bool shoWPassword;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnabled,
      controller: widget.controller,
      style: regularTextStyle,
      maxLines: widget.numberOfLines,
      keyboardType: widget.textInputType,
      validator: (value) {
        return widget.validator(value);
      },
      textInputAction: widget.textInputAction,
      onChanged: ((value) {
        widget.onChanged(value);
      }),
      decoration: InputDecoration(
        suffixIcon: widget.showClearSuffix
            ? clearSuffixIconButton()
            : widget.isPassword
                ? togglePasswordVisibilityIconButton()
                : const SizedBox.shrink(),
        hintText: widget.hintTitle,
        hintStyle: regularTextStyle.copyWith(
          color: customBlackColor.withOpacity(
            .5,
          ),
        ),
        errorStyle: regularTextStyle.copyWith(
          color: Colors.red,
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
            color: customBlackColor.withOpacity(.1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        fillColor: greyColor,
        filled: true,
      ),
      obscureText: shoWPassword,
      // obscuringCharacter: "*",
    );
  }

  GestureDetector togglePasswordVisibilityIconButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          shoWPassword = !shoWPassword;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          shoWPassword ? Icons.visibility : Icons.visibility_off,
          color: customBlackColor.withOpacity(.6),
          size: 16,
        ),
      ),
    );
  }

  GestureDetector clearSuffixIconButton() {
    return GestureDetector(
      onTap: () {
        widget.suffixButtonAction();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          Icons.clear,
          color: customBlackColor.withOpacity(.6),
          size: 16,
        ),
      ),
    );
  }
}
