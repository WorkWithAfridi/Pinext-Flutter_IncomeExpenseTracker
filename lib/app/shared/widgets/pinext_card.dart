import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/domentions.dart';
import '../../app_data/theme_data/colors.dart';

class PinextCard extends StatelessWidget {
  PinextCard({
    Key? key,
    this.isSelected = false,
    this.cardColor = customBlueColor,
    this.title = "Test Title",
    this.balance = 0.00,
    required this.lastTransactionDate,
  }) : super(key: key);

  bool isSelected;
  Color cardColor;
  double balance;
  String title;
  String lastTransactionDate;

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
          color: cardColor,
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: whiteColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                          Text(balance.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: whiteColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                        ],
                      )
                    ],
                  ),
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
                      FittedBox(
                        child: Text(
                          timeago.format(
                            DateTime.parse(
                              lastTransactionDate,
                            ),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            isSelected
                ? const Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.amber,
                      size: 50,
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
