import 'package:flutter/material.dart';

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';

class InfoWidget extends StatelessWidget {
  InfoWidget({
    Key? key,
    required this.infoText,
  }) : super(key: key);

  String infoText;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      splashRadius: 0,
      surfaceTintColor: Colors.transparent,
      padding: const EdgeInsets.all(0),

      // elevation: 6,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                defaultBorder,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(
                  defaultPadding,
                ),
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(
                    defaultBorder,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.info,
                    //       color: customDarkBBlueColor,
                    //     ),
                    //     const SizedBox(
                    //       width: 4,
                    //     ),
                    //     Text(
                    //       "Info.",
                    //       style: boldTextStyle,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 4,
                    // ),
                    Text(
                      infoText,
                      style: regularTextStyle.copyWith(
                        color: customBlackColor.withOpacity(
                          .6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      onSelected: (value) {},
      position: PopupMenuPosition.over,
      child: const Icon(
        Icons.help,
        color: customBlueColor,
      ),
    );
  }
}
