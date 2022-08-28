import 'dart:developer';
import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/bloc/add_card_cubit/add_card_cubit.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';
import 'package:uuid/uuid.dart';

import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';
import '../../bloc/signin_cubit/signin_cubit_cubit.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';

class AddPinextCardScreen extends StatelessWidget {
  const AddPinextCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCardCubit(),
      child: const AddPinextCardView(),
    );
  }
}

class AddPinextCardView extends StatefulWidget {
  const AddPinextCardView({Key? key}) : super(key: key);

  @override
  State<AddPinextCardView> createState() => _AddPinextCardViewState();
}

class _AddPinextCardViewState extends State<AddPinextCardView> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController balanceController;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    balanceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Rebuilding");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
          ),
        ),
        title: Text(
          "Adding a new Pinext card",
          style: regularTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Card title",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(
                        .6,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GetCustomTextField(
                    controller: titleController,
                    hintTitle: "Enter title",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Card description (if any)",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(
                        .6,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GetCustomTextField(
                    controller: descriptionController,
                    hintTitle: "Enter description",
                    numberOfLines: 5,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Current balance",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(
                        .6,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GetCustomTextField(
                    controller: balanceController,
                    hintTitle: "Enter card balance",
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Select card color",
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
              height: 36,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    ListView.builder(
                      itemCount: listOfCardColors.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        String color = listOfCardColors[index];
                        late Color cardColor = getColorFromString(color);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              context.read<AddCardCubit>().changeColor(color);
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: getWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  BlocBuilder<AddCardCubit, AddCardState>(
                    builder: (context, state) {
                      String color = state.color;
                      late Color cardColor = getColorFromString(color);
                      return PinextCard(
                        cardColor: cardColor,
                        title: "Example Wallet",
                        balance: 123456.789,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: BlocConsumer<AddCardCubit, AddCardState>(
                listener: (context, state) {
                  if (state is AddCardErrorState) {
                    ElegantNotification.error(
                      title: Text(
                        "ERROR :(",
                        style: boldTextStyle,
                      ),
                      description: Text(
                        "An error occurred while trying to add you card, please try again later!",
                        style: regularTextStyle,
                      ),
                      width: getWidth(context) * .9,
                      animationDuration: const Duration(milliseconds: 200),
                      toastDuration: const Duration(seconds: 5),
                    ).show(context);
                    context.read<AddCardCubit>().reset();
                  }
                  if (state is AddCardSuccessState) {
                    PinextCardModel newPinextCard = PinextCardModel(
                      cardId: const Uuid().v4().toString(),
                      title: state.title,
                      description: state.description,
                      balance: state.balance,
                      color: state.color,
                      lastTransactionData: DateTime.now().toString(),
                    );
                    context.read<SigninCubit>().addCard(
                          newPinextCard,
                        );
                    Navigator.pop(context);

                    ElegantNotification.success(
                      title: Text(
                        "Pinext Card added!!",
                        style: boldTextStyle,
                      ),
                      description: Text(
                        "A new card has been added to your card list.",
                        style: regularTextStyle,
                      ),
                      width: getWidth(context) * .9,
                      animationDuration: const Duration(milliseconds: 200),
                      toastDuration: const Duration(seconds: 5),
                    ).show(context);
                    context.read<AddCardCubit>().reset();
                  }
                },
                builder: (context, state) {
                  return GetCustomButton(
                    title: "Add Pinext Card",
                    titleColor: whiteColor,
                    buttonColor: customBlueColor,
                    isLoading: false,
                    callBackFunction: () {
                      context.read<AddCardCubit>().addCard(
                            titleController.text,
                            descriptionController.text,
                            balanceController.text,
                            state.color,
                          );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
