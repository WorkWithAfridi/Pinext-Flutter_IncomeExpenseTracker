import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class InfoWidget extends StatelessWidget {
  InfoWidget({
    super.key,
    required this.infoText,
  });

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
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(
                    defaultBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.info,
                    //       color: blackColor,
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
        color: primaryColor,
      ),
    );
  }
}
