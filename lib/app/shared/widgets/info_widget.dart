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
    return Container(
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
          Row(
            children: [
              const Icon(
                Icons.info,
                color: customDarkBBlueColor,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "Info.",
                style: boldTextStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
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
    );
  }
}
