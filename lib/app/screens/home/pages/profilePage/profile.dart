import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/appVersion.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(
        defaultPadding,
      ),
      height: height,
      width: width,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: width,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                      bottom: 10,
                    ),
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          defaultBorder,
                        ),
                        color: customBlackColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                                border: Border.all(
                                  color: whiteColor,
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.settings,
                                color: whiteColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Settings",
                            style: regularTextStyle.copyWith(
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          defaultBorder,
                        ),
                        color: customBlueColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  60,
                                ),
                                border: Border.all(
                                  color: whiteColor,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                UserHandler().currentUser.username[0],
                                style: boldTextStyle.copyWith(
                                  color: whiteColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            UserHandler().currentUser.username,
                            style: boldTextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "(Profile)",
                            style: regularTextStyle.copyWith(
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                defaultBorder,
              ),
              color: greyColor,
            ),
            alignment: Alignment.center,
            child: Text(
              "🔥  Request new features!",
              style: regularTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 80,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                defaultBorder,
              ),
              color: customBlueColor,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.edit,
                  color: whiteColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Enjoying ",
                            style: regularTextStyle.copyWith(
                              fontSize: 16,
                              color: whiteColor,
                            ),
                          ),
                          TextSpan(
                            text: "Pinext?",
                            style: boldTextStyle.copyWith(
                              fontSize: 16,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Maybe write me a ",
                            style: regularTextStyle.copyWith(
                              fontSize: 16,
                              color: whiteColor,
                            ),
                          ),
                          TextSpan(
                            text: "review",
                            style: boldTextStyle.copyWith(
                              fontSize: 16,
                              color: whiteColor,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.wavy,
                            ),
                          ),
                          TextSpan(
                            text: "! :)",
                            style: regularTextStyle.copyWith(
                              fontSize: 16,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "App Version: $appVersion",
            style: regularTextStyle.copyWith(
              fontSize: 12,
              color: customBlackColor.withOpacity(.3),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
