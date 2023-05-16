import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';

class HomepageGetBalanceWidget extends StatelessWidget {
  const HomepageGetBalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance',
            style: boldTextStyle.copyWith(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.all(
              defaultPadding,
            ),
            width: getWidth(context),
            decoration: BoxDecoration(
              color: darkPurpleColor,
              borderRadius: BorderRadius.circular(
                defaultBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your current NET. balance is',
                  style: regularTextStyle.copyWith(
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Builder(
                  builder: (context) {
                    final state = context.watch<UserBloc>().state;
                    final demoBlocState = context.watch<DemoBloc>().state;
                    if (state is AuthenticatedUserState) {
                      return Text(
                        demoBlocState is DemoEnabledState ? '750000 Tk' : '${state.netBalance} Tk',
                        style: boldTextStyle.copyWith(
                          fontSize: 25,
                          color: whiteColor,
                        ),
                      );
                    }
                    return Text(
                      'Loading...',
                      style: boldTextStyle.copyWith(
                        fontSize: 20,
                        color: whiteColor,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
