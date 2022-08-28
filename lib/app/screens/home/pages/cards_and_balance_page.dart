import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/handlers/user_handler.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../app_data/theme_data/colors.dart';
import '../../../models/pinext_card_model.dart';
import '../../../services/firebase_services.dart';
import '../../../shared/widgets/pinext_card_minimized.dart';

class CardsAndBalancePage extends StatelessWidget {
  const CardsAndBalancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Pinext",
              style: regularTextStyle.copyWith(
                color: customBlackColor.withOpacity(.6),
              ),
            ),
            Text(
              "Cards and Balances",
              style: boldTextStyle.copyWith(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(
                35,
              ),
              height: 180,
              width: getWidth(context),
              decoration: BoxDecoration(
                color: customBlackColor,
                borderRadius: BorderRadius.circular(
                  defaultBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Your current Balance is",
                    style: boldTextStyle.copyWith(
                      color: whiteColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      UserHandler().currentUser.netBalance,
                      style: boldTextStyle.copyWith(
                        color: whiteColor,
                        fontSize: 50,
                      ),
                    ),
                  ),
                  Text(
                    "Taka",
                    style: boldTextStyle.copyWith(
                      color: whiteColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Manage Cards",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            StreamBuilder(
              stream: FirebaseServices()
                  .firebaseFirestore
                  .collection("pinext_users")
                  .doc(FirebaseServices().getUserId())
                  .collection("pinext_cards")
                  .snapshots(),
              builder: ((context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    PinextCardModel pinextCardModel = PinextCardModel.fromMap(
                      snapshot.data!.docs[index].data(),
                    );

                    String color = pinextCardModel.color;
                    late Color cardColor = getColorFromString(color);
                    return PinextCardMinimized(
                        pinextCardModel: pinextCardModel);
                  }),
                );
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "New Card??",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(
                  defaultBorder,
                ),
              ),
              alignment: Alignment.center,
              width: getWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25,
                      ),
                      border: Border.all(
                        color: customBlackColor.withOpacity(.4),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: customBlackColor.withOpacity(.4),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Add a new card",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
