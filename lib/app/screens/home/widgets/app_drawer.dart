import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/services/handlers/app_handler.dart';

class PinextDrawer extends StatelessWidget {
  const PinextDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: getHeight(context),
        color: greyColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Pinext',
                        style: boldTextStyle.copyWith(
                          height: .9,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'Space',
                        style: boldTextStyle.copyWith(
                          fontSize: 25,
                          color: primaryColor.withOpacity(.6),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          AppHandler().openPortfolio(context);
                        },
                        child: Column(
                          children: [
                            Text(
                              'By',
                              style: regularTextStyle.copyWith(
                                fontSize: 14,
                                color: customBlackColor.withOpacity(.4),
                              ),
                            ),
                            Text(
                              'KYOTO',
                              style: regularTextStyle.copyWith(
                                fontSize: 16,
                                color: customBlackColor.withOpacity(.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                IconButton(
                  onPressed: () {
                    AppHandler().sendBugReport(context);
                  },
                  icon: Icon(
                    FontAwesomeIcons.bug,
                    size: 20,
                    color: customBlackColor.withOpacity(.8),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocListener<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UnauthenticatedUserState) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        ROUTES.getLoginRoute,
                        (route) => false,
                      );
                    }
                  },
                  child: IconButton(
                    onPressed: () async {
                      context.read<UserBloc>().add(
                            SignOutUserEvent(context: context),
                          );
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.redAccent[400],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
