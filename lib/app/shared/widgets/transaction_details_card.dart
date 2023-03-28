import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/screens/add_and_view_transaction/add_and_view_transaction.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/shared/widgets/gradient_text.dart';

class TransactionDetailsCard extends StatefulWidget {
  TransactionDetailsCard({
    super.key,
    required this.pinextTransactionModel,
    required this.isLastIndex,
  });

  final PinextTransactionModel pinextTransactionModel;
  bool isLastIndex;

  @override
  State<TransactionDetailsCard> createState() => _TransactionDetailsCardState();
}

class _TransactionDetailsCardState extends State<TransactionDetailsCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CustomTransitionPageRoute(
            childWidget: AddAndViewTransactionScreen(
              isViewOnly: true,
              pinextTransactionModel: widget.pinextTransactionModel,
            ),
          ),
        );
      },
      child: Builder(
        builder: (context) {
          final demoBlocState = context.watch<DemoBloc>().state;
          return Container(
            color: Colors.transparent,
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.pinextTransactionModel.transactionDate)),
                      style: regularTextStyle.copyWith(
                        color: customBlackColor.withOpacity(.80),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: FutureBuilder(
                              future: CardHandler().getCardData(widget.pinextTransactionModel.cardId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final cardDetails = snapshot.data as PinextCardModel;
                                  return GradientText(
                                    demoBlocState is DemoEnabledState ? 'Bank' : cardDetails.title,
                                    colors: GetGradientFromString(
                                      cardDetails.color,
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          Text(
                            ' - ',
                            style: regularTextStyle.copyWith(
                              color: customBlackColor.withOpacity(.80),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Flexible(
                            flex: 4,
                            child: Text(
                              demoBlocState is DemoEnabledState
                                  ? 'a natural looking block of text.'.toLowerCase().capitalize()
                                  : widget.pinextTransactionModel.details.toLowerCase().capitalize(),
                              style: regularTextStyle.copyWith(
                                color: customBlackColor.withOpacity(.80),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      // width: 100,
                      alignment: Alignment.centerRight,
                      child: FutureBuilder(
                        future: CardHandler().getCardData(widget.pinextTransactionModel.cardId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final cardDetails = snapshot.data as PinextCardModel;
                            return Text(
                              widget.pinextTransactionModel.transactionType == 'Expense'
                                  ? '- ${widget.pinextTransactionModel.amount} Tk'
                                  : '+ ${widget.pinextTransactionModel.amount} Tk',
                              style: boldTextStyle.copyWith(
                                color: widget.pinextTransactionModel.transactionType == 'Expense' ? Colors.red : Colors.green,
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
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
                    //     AntIcons.editOutlined,
                    //     color: primaryColor,
                    //     size: 16,
                    //   ),
                    // )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                if (widget.isLastIndex)
                  const SizedBox.shrink()
                else
                  Container(
                    height: 1,
                    width: getWidth(context),
                    color: customBlackColor.withOpacity(.05),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
