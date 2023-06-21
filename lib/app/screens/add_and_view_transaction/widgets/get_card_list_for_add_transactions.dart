import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';

class GetCardListForAddTransaction extends StatelessWidget {
  GetCardListForAddTransaction({
    required this.isViewOnly,
    super.key,
    this.viewTransactionModel,
  });

  bool isViewOnly;
  PinextTransactionModel? viewTransactionModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getCardHeight(context) + 10,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(
              width: defaultPadding,
            ),
            StreamBuilder(
              stream: isViewOnly
                  ? FirebaseServices()
                      .firebaseFirestore
                      .collection('pinext_users')
                      .doc(FirebaseServices().getUserId())
                      .collection('pinext_cards')
                      .where('cardId', isEqualTo: viewTransactionModel!.cardId)
                      .snapshots()
                  : FirebaseServices()
                      .firebaseFirestore
                      .collection('pinext_users')
                      .doc(FirebaseServices().getUserId())
                      .collection('pinext_cards')
                      .orderBy(
                        'lastTransactionData',
                        descending: true,
                      )
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: getWidth(context) - defaultPadding,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    width: getWidth(context) - defaultPadding * 2,
                    alignment: Alignment.center,
                    child: Text(
                      'Please add a Pinext card to view your cards list here.',
                      style: regularTextStyle.copyWith(
                        color: customBlackColor.withOpacity(.4),
                      ),
                      maxLines: 3,
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final pinextCardModel = PinextCardModel.fromMap(
                      snapshot.data!.docs[index].data(),
                    );

                    final color = pinextCardModel.color;
                    late final cardColor = getColorFromString(color);

                    return BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
                      builder: (context, state) {
                        final Widget pinextCardWidget = GestureDetector(
                          onTap: () {
                            if (!isViewOnly) {
                              if (state.selectedCardNo == pinextCardModel.cardId) {
                                context.read<AddTransactionsCubit>().selectCard('none');
                              } else {
                                context.read<AddTransactionsCubit>().selectCard(pinextCardModel.cardId);
                              }
                            }
                          },
                          child: PinextCard(
                            title: pinextCardModel.title,
                            balance: pinextCardModel.balance,
                            cardColor: pinextCardModel.color,
                            isSelected: isViewOnly ? false : state.selectedCardNo == pinextCardModel.cardId,
                            lastTransactionDate: pinextCardModel.lastTransactionData,
                            cardDetails: pinextCardModel.description,
                            cardId: pinextCardModel.cardId,
                            // cardModel: pinextCardModel,
                            // cardModel: pinextCardModel,
                          ),
                        );
                        return pinextCardWidget;
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(
              width: defaultPadding - 10,
            ),
          ],
        ),
      ),
    );
  }
}
