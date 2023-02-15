import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_subscription_cubit/add_subscription_cubit.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';

class AddSubscriptionPage extends StatelessWidget {
  const AddSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddSubscriptionCubit(),
      child: AddSubscriptionView(),
    );
  }
}

class AddSubscriptionView extends StatelessWidget {
  AddSubscriptionView({
    super.key,
  });

  TextEditingController netBalanceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: customBlackColor,
          ),
        ),
        title: Text(
          "Adding a new subscription",
          style: regularTextStyle,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Title",
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(
                            .6,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: TextEditingController(),
                        hintTitle: "Netflix subscription",
                        textInputType: TextInputType.number,
                        onChanged: (String value) {},
                        validator: (String value) {
                          return InputValidation(value).isNotEmpty();
                        },
                        suffixButtonAction: () {},
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Description",
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(
                            .6,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        numberOfLines: 4,
                        controller: TextEditingController(),
                        hintTitle: "",
                        textInputType: TextInputType.number,
                        onChanged: (String value) {},
                        validator: (String value) {
                          return null;
                        },
                        suffixButtonAction: () {},
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Amount",
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(
                            .6,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        numberOfLines: 1,
                        controller: TextEditingController(),
                        hintTitle: "",
                        textInputType: TextInputType.number,
                        onChanged: (String value) {},
                        validator: (String value) {
                          return InputValidation(value).isCorrectNumber();
                        },
                        suffixButtonAction: () {},
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                    left: defaultPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Automatically pay",
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(
                            .6,
                          ),
                        ),
                      ),
                      BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
                        builder: (context, state) {
                          return Switch(
                            value: state.automaticallyPayActivated,
                            activeColor: customBlueColor,
                            onChanged: (value) {
                              context.read<AddSubscriptionCubit>().toogleAutomaticallyPaySwitch(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InfoWidget(
                        infoText:
                            "Enabling this option will automatically deduct the subscription amount at the start of everymonth, from the selected card!",
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Select card",
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(
                            .6,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 185,
                  child: SingleChildScrollView(
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
                              .collection("pinext_users")
                              .doc(FirebaseServices().getUserId())
                              .collection("pinext_cards")
                              .orderBy(
                                'lastTransactionData',
                                descending: true,
                              )
                              .snapshots(),
                          builder: ((context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
                              builder: (cubitContext, state) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: ((context, index) {
                                    PinextCardModel pinextCardModel = PinextCardModel.fromMap(
                                      snapshot.data!.docs[index].data(),
                                    );

                                    String color = pinextCardModel.color;
                                    late Color cardColor = getColorFromString(color);

                                    return GestureDetector(
                                      onTap: () {
                                        cubitContext.read<AddSubscriptionCubit>().selectCard(pinextCardModel.cardId);
                                      },
                                      child: PinextCard(
                                        title: pinextCardModel.title,
                                        balance: pinextCardModel.balance,
                                        cardColor: cardColor,
                                        isSelected: state.selectedCardNo == pinextCardModel.cardId,
                                        lastTransactionDate: pinextCardModel.lastTransactionData,
                                        cardDetails: pinextCardModel.description,
                                        // cardModel: pinextCardModel,
                                      ),
                                    );
                                  }),
                                );
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          width: defaultPadding - 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: GetCustomButton(
                    title: "Save Subscription",
                    titleColor: whiteColor,
                    buttonColor: customBlueColor,
                    callBackFunction: () {},
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
