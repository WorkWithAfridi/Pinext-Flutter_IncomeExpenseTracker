import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/homeframe_cubit/homeframe_page_cubit.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/shared/widgets/transaction_details_card.dart';

class HomepageGetPastTransactionsWidget extends StatelessWidget {
  const HomepageGetPastTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Last 10 transactions',
              style: boldTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<HomeframeCubit>().changeHomeframePage(1);
              },
              child: Text(
                'View all',
                style: regularTextStyle.copyWith(
                  fontSize: 14,
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        BlocBuilder<ArchiveCubit, ArchiveState>(
          builder: (context, archiveState) {
            if (archiveState.archiveList.isEmpty) {
              return Text(
                '404 - No record found!',
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // options: const LiveOptions(
              //   showItemInterval: Duration(milliseconds: 60),
              //   showItemDuration: Duration(milliseconds: 120),
              // ),
              itemCount: archiveState.archiveList.length > 10 ? 10 : archiveState.archiveList.length,
              itemBuilder: (
                context,
                index,
              ) {
                final listLen = archiveState.archiveList.length > 10 ? 10 : archiveState.archiveList.length;
                return TransactionDetailsCard(
                  pinextTransactionModel: archiveState.archiveList[index] as PinextTransactionModel,
                  isLastIndex: index == listLen - 1,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
