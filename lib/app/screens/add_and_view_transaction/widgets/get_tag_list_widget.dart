import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';

class GetTagsList extends StatelessWidget {
  GetTagsList({
    required this.isViewOnly,
    required this.pinextTransactionModel,
    super.key,
  });

  bool isViewOnly;

  PinextTransactionModel? pinextTransactionModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: boldTextStyle.copyWith(
            color: customBlackColor.withOpacity(
              .6,
            ),
          ),
        ),
        BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
          builder: (context, state) {
            if (isViewOnly) {
              return Chip(
                label: Text(
                  pinextTransactionModel!.transactionTag,
                  style: regularTextStyle.copyWith(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: primaryColor,
              );
            }
            return Wrap(
              spacing: 5,
              runSpacing: -8,
              children: [
                ...List.generate(
                  transactionTags.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        final selectedTag = transactionTags[index];
                        if (state.selectedTag != selectedTag) {
                          context.read<AddTransactionsCubit>().changeSelectedTag(selectedTag);
                        } else {
                          context.read<AddTransactionsCubit>().changeSelectedTag('');
                        }
                      },
                      child: Chip(
                        label: Text(
                          transactionTags[index],
                          style: regularTextStyle.copyWith(
                            color: transactionTags[index] == state.selectedTag ? whiteColor : customBlackColor.withOpacity(.6),
                            fontWeight: transactionTags[index] == state.selectedTag ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        backgroundColor: transactionTags[index] == state.selectedTag ? primaryColor : greyColor,
                      ),
                    );
                  },
                ).toList(),
              ],
            );
          },
        ),
      ],
    );
  }
}
