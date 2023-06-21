import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/home/pages/app_settings_screen/widgets/get_settings_button_with_icon.dart';

class GetResetAccountButton extends StatelessWidget {
  const GetResetAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return GetSettingsButtonWithIcon(
          onTapFunction: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Proceed with Caution\nIrreversible Action',
                    style: boldTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text(
                          'Please read this warning carefully before proceeding. Resetting account is an irreversible action that cannot be undone. This service will remove all your account details and associated data. There will be no way to recover your information once the deletion is complete.\n \nTo proceed, click the "Approve" button below. If you have any concerns or need further assistance, please click "Cancel" and reach out to our support team.',
                          style: regularTextStyle,
                        ),
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultBorder),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(
                            .8,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Approve',
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(
                            .8,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (state is AuthenticatedUserState) {
                          context.read<UserBloc>().add(
                                ResetUserDataEvent(
                                  currentState: AuthenticatedUserState(
                                    userId: state.userId,
                                    username: state.username,
                                    emailAddress: state.emailAddress,
                                    netBalance: state.netBalance,
                                    monthlyBudget: state.monthlyBudget,
                                    monthlyExpenses: state.monthlyExpenses,
                                    dailyExpenses: state.dailyExpenses,
                                    weeklyExpenses: state.weeklyExpenses,
                                    monthlySavings: state.monthlySavings,
                                    accountCreatedOn: state.accountCreatedOn,
                                    currentYear: state.currentYear,
                                    currentDate: state.currentDate,
                                    currentMonth: state.currentMonth,
                                    monthlyEarnings: state.monthlyEarnings,
                                    currentWeekOfTheYear: state.currentWeekOfTheYear,
                                    regionCode: state.regionCode,
                                  ),
                                  context: context,
                                ),
                              );
                        }
                      },
                    ),
                  ],
                  actionsPadding: dialogButtonPadding,
                );
              },
            );
          },
          label: 'Reset account',
          icon: Icons.restore,
          iconSize: 18,
        );
      },
    );
  }
}
