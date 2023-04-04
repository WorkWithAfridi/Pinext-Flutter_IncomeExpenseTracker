import 'package:flutter/material.dart';

const Color primaryColor = Color(0xff0A0F34); //Color(0xff783EF0);
const Color darkPurpleColor = Color(0xff3b47a1);
const Color cyanColor = Color(0xffA6E6EF);
const Color whiteColor = Color(0xffFFFFFF);
const Color customBlackColor = Color(0xff0A0F34);
const Color greyColor = Color(0xffF7F7F7);

Color getColorFromString(String colorInStringFormat) {
  final color = colorInStringFormat;
  late Color cardColor;
  if (color == 'Black') {
    cardColor = Colors.black;
  } else if (color == 'Red') {
    cardColor = Colors.red;
  } else if (color == 'Purple') {
    cardColor = Colors.purple;
  } else if (color == 'Green') {
    cardColor = Colors.green;
  } else if (color == 'Light Blue') {
    cardColor = primaryColor;
  } else if (color == 'Dark Blue') {
    cardColor = customBlackColor;
  } else {
    cardColor = primaryColor;
  }
  return cardColor;
}

String getStringFromColor(Color colorInColorFormat) {
  final cardColor = colorInColorFormat;
  late String color;
  if (cardColor == Colors.black) {
    color = 'Black';
  } else if (cardColor == Colors.red) {
    color = 'Red';
  } else if (cardColor == Colors.purple) {
    color = 'Purple';
  } else if (cardColor == Colors.green) {
    color = 'Green';
  } else if (cardColor == primaryColor) {
    color = 'Light Blue';
  } else if (cardColor == customBlackColor) {
    color = 'Dark Blue';
  } else {
    color = 'none';
  }
  return color;
}

List listOfCardColors = [
  'Deep Raven',
  'Midnight Indigo',
  'Amber Peach',
  'Dandelione',
  'Cobalt Leaf',
  'Triplet Blaze',
  'Scarlet Red',
  'Ocean Blue',
];

List<Color> GetGradientFromString(String color) {
  var colorList = <Color>[];
  switch (color) {
    case 'Deep Raven':
      colorList = [
        const Color(0xff0E1c26),
        const Color(0xff294861),
      ];
      break;
    case 'Midnight Indigo':
      colorList = [
        const Color(0xff0094FF),
        const Color(0xff8F00FF),
      ];
      break;
    case 'Amber Peach':
      colorList = [
        const Color(0xffe60b09),
        const Color(0xffF89B29),
      ];
      break;
    case 'Dandelione':
      colorList = [
        const Color(0xffFF9900),
        const Color(0xffFFBD5B),
      ];
      break;
    case 'Cobalt Leaf':
      colorList = [
        const Color(0xff2AF598),
        const Color(0xff009EFD),
      ];
      break;
    case 'Triplet Blaze':
      colorList = [
        const Color(0xffFF0CE7),
        const Color(0xffFF0000),
        const Color(0xffF9A707),
      ];
      break;
    case 'Scarlet Red':
      colorList = [
        const Color(0xffFF0F7B),
        const Color(0xffD40404),
      ];
      break;
    case 'Ocean Blue':
      colorList = [
        const Color(0xff0075FF),
        const Color(0xff00A3FF),
      ];
      break;
    default:
      colorList = [
        primaryColor,
        primaryColor,
      ];
  }
  return colorList;
}
