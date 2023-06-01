import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/edit_net_balance_screen.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

class HomepageGetBalanceWidget extends StatelessWidget {
  HomepageGetBalanceWidget({
    super.key,
    this.tapToOpenUpdateNetBalancePage = true,
  });

  bool tapToOpenUpdateNetBalancePage;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final state = context.watch<UserBloc>().state;
        final demoBlocState = context.watch<DemoBloc>().state;
        if (state is AuthenticatedUserState) {
          return GestureDetector(
            onTap: () {
              if (tapToOpenUpdateNetBalancePage) {
                Navigator.push(
                  context,
                  CustomTransitionPageRoute(
                    childWidget: EditNetBalanceScreen(
                      netBalance: state.netBalance,
                    ),
                  ),
                );
              }
            },
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your current NET. balance is',
                              style: regularTextStyle.copyWith(
                                color: whiteColor,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              demoBlocState is DemoEnabledState
                                  ? '750000 ${UserHandler().currentUser.currencySymbol}'
                                  : '${state.netBalance} ${UserHandler().currentUser.currencySymbol}',
                              style: boldTextStyle.copyWith(
                                fontSize: 30,
                                color: whiteColor,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      if (tapToOpenUpdateNetBalancePage)
                        const Icon(
                          AntIcons.editOutlined,
                          color: Colors.white,
                          size: 20,
                        )
                      else
                        const SizedBox.shrink()
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
        return const SizedBox.shrink();
      },
    );
  }
}
