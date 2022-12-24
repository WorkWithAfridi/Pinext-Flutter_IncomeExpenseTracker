import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

import '../../app_data/app_constants/domentions.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/custom_transition_page_route/custom_transition_page_route.dart';
import '../../app_data/theme_data/colors.dart';
import '../../models/pinext_transaction_model.dart';
import '../../screens/add_and_view_transaction/add_and_view_transaction.dart';

class TransactionDetailsCard extends StatefulWidget {
  const TransactionDetailsCard({
    Key? key,
    required this.pinextTransactionModel,
  }) : super(key: key);

  final PinextTransactionModel pinextTransactionModel;

  @override
  State<TransactionDetailsCard> createState() => _TransactionDetailsCardState();
}

class _TransactionDetailsCardState extends State<TransactionDetailsCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCardDetails();
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
            isAQuickAction: false,
            pinextTransactionModel: widget.pinextTransactionModel,
          )),
        );
      },
      child: Container(
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
                  width: 15,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: FutureBuilder(
                          initialData: "",
                          future: getCardTitle(),
                          builder: ((context, snapshot) {
                            return Text(
                              snapshot.data.toString(),
                              style: regularTextStyle.copyWith(
                                color: customBlackColor.withOpacity(.80),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                        ),
                      ),
                      Text(
                        " - ",
                        style: regularTextStyle.copyWith(
                          color: customBlackColor.withOpacity(.80),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Flexible(
                        flex: 3,
                        child: Text(
                          widget.pinextTransactionModel.details,
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
                  child: Text(
                    widget.pinextTransactionModel.transactionType == 'Expense'
                        ? "- ${widget.pinextTransactionModel.amount}Tk"
                        : "+ ${widget.pinextTransactionModel.amount}Tk",
                    style: boldTextStyle.copyWith(
                      color: widget.pinextTransactionModel.transactionType == 'Expense' ? Colors.red : Colors.green,
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
      ),
    );
  }

  Future<PinextCardModel> getCardDetails() async {
    String cardId = widget.pinextTransactionModel.cardId;
    DocumentSnapshot cardData = await FirebaseServices()
        .firebaseFirestore
        .collection("pinext_users")
        .doc(UserHandler().currentUser.userId)
        .collection("pinext_cards")
        .doc(cardId)
        .get();

    return PinextCardModel.fromMap(cardData.data() as Map<String, dynamic>);
  }

  Future<String> getCardTitle() async {
    PinextCardModel card = await getCardDetails();
    return card.title;
  }
}
