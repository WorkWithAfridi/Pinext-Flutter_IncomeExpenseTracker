import 'package:flutter/material.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/domentions.dart';
import '../../app_data/theme_data/colors.dart';

class PinextCard extends StatelessWidget {
  PinextCard({
    Key? key,
    this.isSelected = false,
  }) : super(key: key);

  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.all(
          15,
        ),
        height: 180,
        width: getWidth(context) * .8,
        decoration: BoxDecoration(
          color: customBlueColor,
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
          border: Border.all(
            color: isSelected ? customBlackColor : Colors.transparent,
            width: 5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Bkash",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: whiteColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current balance",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: whiteColor.withOpacity(.4),
                      ),
                    ),
                    const Text(
                      "67000Tk",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: whiteColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last transaction",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                      color: whiteColor.withOpacity(.4),
                    ),
                  ),
                  const Text(
                    "12/12/12",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
