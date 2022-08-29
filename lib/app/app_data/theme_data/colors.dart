import 'package:flutter/material.dart';

const Color customBlueColor = Color(0xff4F62C1);
const Color cyanColor = Color(0xffA6E6EF);
const Color whiteColor = Color(0xffFFFFFF);
const Color customBlackColor = Color(0xff0A0F34);
const Color greyColor = Color(0xffF7F7F7);

Color getColorFromString(String colorInStringFormat) {
  String color = colorInStringFormat;
  late Color cardColor;
  if (color == "Black") {
    cardColor = Colors.black;
  } else if (color == "Red") {
    cardColor = Colors.red;
  } else if (color == "Purple") {
    cardColor = Colors.purple;
  } else if (color == "Green") {
    cardColor = Colors.green;
  } else if (color == "Light Blue") {
    cardColor = customBlueColor;
  } else if (color == "Dark Blue") {
    cardColor = customBlackColor;
  } else {
    cardColor = customBlueColor;
  }
  return cardColor;
}

String getStringFromColor(Color colorInColorFormat) {
  Color cardColor = colorInColorFormat;
  late String color;
  if (cardColor == Colors.black) {
    color = "Black";
  } else if (cardColor == Colors.red) {
    color = "Red";
  } else if (cardColor == Colors.purple) {
    color = "Purple";
  } else if (cardColor == Colors.green) {
    color = "Green";
  } else if (cardColor == customBlueColor) {
    color = "Light Blue";
  } else if (cardColor == customBlackColor) {
    color = "Dark Blue";
  } else {
    color = "none";
  }
  return color;
}

List listOfCardColors = [
  "Black",
  "Red",
  "Purple",
  "Green",
  "Light Blue",
  "Dark Blue"
];
