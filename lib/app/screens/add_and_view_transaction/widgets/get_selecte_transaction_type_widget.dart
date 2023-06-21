import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';

class GetSelectTransactionTypeWidget extends StatelessWidget {
  GetSelectTransactionTypeWidget({
    required this.isViewOnly,
    super.key,
  });
  bool isViewOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction type',
          style: boldTextStyle.copyWith(
            color: customBlackColor.withOpacity(
              .6,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 40,
          child: BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
            builder: (context, state) {
              return Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (!isViewOnly) {
                          context.read<AddTransactionsCubit>().changeSelectedTransactionMode(SelectedTransactionMode.income);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultBorder),
                            color: state.selectedTransactionMode == SelectedTransactionMode.income ? greyColor : Colors.transparent,
                          ),
                          child: Text(
                            'Deposit',
                            style: state.selectedTransactionMode == SelectedTransactionMode.income
                                ? boldTextStyle.copyWith(
                                    color: primaryColor,
                                    fontSize: 20,
                                  )
                                : boldTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.4),
                                    fontSize: 20,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: .5,
                    height: double.maxFinite,
                    color: customBlackColor.withOpacity(.2),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (!isViewOnly) {
                          context.read<AddTransactionsCubit>().changeSelectedTransactionMode(SelectedTransactionMode.enpense);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultBorder),
                            color: state.selectedTransactionMode == SelectedTransactionMode.enpense ? greyColor : Colors.transparent,
                          ),
                          child: Text(
                            'Withdrawal ',
                            style: state.selectedTransactionMode == SelectedTransactionMode.enpense
                                ? boldTextStyle.copyWith(
                                    color: primaryColor,
                                    fontSize: 20,
                                  )
                                : boldTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.4),
                                    fontSize: 20,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
