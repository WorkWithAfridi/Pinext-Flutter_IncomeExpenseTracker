import 'package:flutter/material.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../app_data/theme_data/colors.dart';

class CardsAndBalancePage extends StatelessWidget {
  const CardsAndBalancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Pinext",
              style: regularTextStyle.copyWith(
                color: customBlackColor.withOpacity(.6),
              ),
            ),
            Text(
              "Cards and Balances",
              style: boldTextStyle.copyWith(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(
                35,
              ),
              height: 180,
              width: getWidth(context),
              decoration: BoxDecoration(
                color: customBlackColor,
                borderRadius: BorderRadius.circular(
                  defaultBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Your current Balance is",
                    style: boldTextStyle.copyWith(
                      color: whiteColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      "65000",
                      style: boldTextStyle.copyWith(
                        color: whiteColor,
                        fontSize: 50,
                      ),
                    ),
                  ),
                  Text(
                    "Taka",
                    style: boldTextStyle.copyWith(
                      color: whiteColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Manage Cards",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                return Card(
                  elevation: 0,
                  shadowColor: greyColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      defaultBorder,
                    ),
                  ),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(
                        defaultBorder,
                      ),
                    ),
                    width: getWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Bkash",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: customBlackColor,
                                  ),
                                ),
                                Container(
                                  width: double.maxFinite,
                                  height: .5,
                                  color: customBlackColor.withOpacity(.2),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Current balance",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                        color: customBlackColor.withOpacity(.4),
                                      ),
                                    ),
                                    const Text(
                                      "67000Tk",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: customBlackColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: .5,
                              height: getHeight(context),
                              color: customBlackColor.withOpacity(.2),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Last transaction",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10,
                                      color: customBlackColor.withOpacity(.4),
                                    ),
                                  ),
                                  const Text(
                                    "12/12/12",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: customBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: .5,
                                  height: getHeight(context),
                                  color: customBlackColor.withOpacity(.2),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.edit,
                                      color: customBlackColor,
                                    ),
                                    Container(
                                      width: 55,
                                      height: .5,
                                      color: customBlackColor.withOpacity(.2),
                                    ),
                                    const Icon(
                                      Icons.delete,
                                      color: customBlackColor,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "New Card??",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(
                  defaultBorder,
                ),
              ),
              alignment: Alignment.center,
              width: getWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25,
                      ),
                      border: Border.all(
                        color: customBlackColor.withOpacity(.4),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: customBlackColor.withOpacity(.4),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Add a new card",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
