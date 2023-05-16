import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';

class HomepageGetYourCardsWidget extends StatelessWidget {
  const HomepageGetYourCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                'Your Cards',
                style: boldTextStyle.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(
                width: defaultPadding,
              ),
              StreamBuilder(
                stream: FirebaseServices()
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
                    return const Center(
                      child: SizedBox.shrink(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Text(
                      'Please add a Pinext card to view your cards details here.',
                      style: regularTextStyle.copyWith(
                        color: customBlackColor.withOpacity(.4),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 185,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final pinextCardModel = PinextCardModel.fromMap(
                          snapshot.data!.docs[index].data(),
                        );

                        return PinextCard(
                          title: pinextCardModel.title,
                          balance: pinextCardModel.balance,
                          cardColor: pinextCardModel.color,
                          lastTransactionDate: pinextCardModel.lastTransactionData,
                          cardDetails: pinextCardModel.description,
                          cardModel: pinextCardModel,
                          cardId: pinextCardModel.cardId,
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                width: defaultPadding - 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
