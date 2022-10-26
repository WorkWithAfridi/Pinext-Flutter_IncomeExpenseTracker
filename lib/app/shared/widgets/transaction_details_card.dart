import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_data/app_constants/domentions.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/custom_transition_page_route/custom_transition_page_route.dart';
import '../../app_data/theme_data/colors.dart';
import '../../models/pinext_transaction_model.dart';
import '../../screens/add_and_view_transaction/add_and_view_transaction.dart';

class TransactionDetailsCard extends StatelessWidget {
  const TransactionDetailsCard({
    Key? key,
    required this.pinextTransactionModel,
  }) : super(key: key);

  final PinextTransactionModel pinextTransactionModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CustomTransitionPageRoute(
              childWidget: AddAndViewTransactionScreen(
            isViewOnly: true,
            isAQuickAction: false,
            pinextTransactionModel: pinextTransactionModel,
          )),
        );
      },
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                DateFormat('dd-MM-yyyy').format(DateTime.parse(pinextTransactionModel.transactionDate)),
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.80),
                ),
              ),
              const SizedBox(
                width: 32,
              ),
              Expanded(
                child: Text(
                  pinextTransactionModel.details,
                  style: regularTextStyle.copyWith(
                    color: customBlackColor.withOpacity(.80),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 100,
                alignment: Alignment.centerRight,
                child: Text(
                  pinextTransactionModel.transactionType == 'Expense'
                      ? "- ${pinextTransactionModel.amount}Tk"
                      : "+ ${pinextTransactionModel.amount}Tk",
                  style: boldTextStyle.copyWith(
                    color: pinextTransactionModel.transactionType == 'Expense' ? Colors.red : Colors.green,
                  ),
                ),
              ),
              // const SizedBox(
              //   width: 8,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       CustomTransitionPageRoute(
              //           childWidget: AddAndEditTransactionScreen(
              //         isEdit: true,
              //         isAQuickAction: false,
              //         pinextTransactionModel: pinextTransactionModel,
              //       )),
              //     );
              //   },
              //   child: const Icon(
              //     Icons.edit,
              //     color: customBlueColor,
              //     size: 16,
              //   ),
              // )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 1,
            width: getWidth(context),
            color: customBlackColor.withOpacity(.05),
          )
        ],
      ),
    );
  }
}
