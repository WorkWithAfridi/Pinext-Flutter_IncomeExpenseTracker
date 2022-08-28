import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';

import '../../app_data/app_constants/constants.dart';
import '../../models/pinext_card_model.dart';
import '../../services/firebase_services.dart';
import '../../shared/widgets/pinext_card.dart';

// class AddTransactionScreen extends StatelessWidget {
//   const AddTransactionScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AddTransactionsCubit(),
//       child: const AddTransactionScreen(),
//     );
//   }
// }

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTransactionsCubit(),
      child: const AddTransactionView(),
    );
  }
}

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({Key? key}) : super(key: key);

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  late TextEditingController amountController;
  late TextEditingController detailsController;

  @override
  void initState() {
    amountController = TextEditingController();
    detailsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          "Adding a new Transaction",
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
                    "Transaction type",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(
                        .6,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                      height: 40,
                      child: BlocBuilder<AddTransactionsCubit,
                          AddTransactionsState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<AddTransactionsCubit>()
                                        .changeSelectedTransactionMode(
                                            SelectedTransactionMode.income);
                                  },
                                  child: Container(
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Income",
                                      style: state.selectedTransactionMode ==
                                              SelectedTransactionMode.income
                                          ? boldTextStyle.copyWith(
                                              color: customBlackColor,
                                              fontSize: 20,
                                            )
                                          : boldTextStyle.copyWith(
                                              color: customBlackColor
                                                  .withOpacity(.4),
                                              fontSize: 20,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: .5,
                                height: double.maxFinite,
                                color: customBlackColor.withOpacity(.2),
                              ),
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: (() {
                                    context
                                        .read<AddTransactionsCubit>()
                                        .changeSelectedTransactionMode(
                                            SelectedTransactionMode.enpense);
                                  }),
                                  child: Container(
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Expense",
                                      style: state.selectedTransactionMode ==
                                              SelectedTransactionMode.enpense
                                          ? boldTextStyle.copyWith(
                                              color: customBlackColor,
                                              fontSize: 20,
                                            )
                                          : boldTextStyle.copyWith(
                                              color: customBlackColor
                                                  .withOpacity(.4),
                                              fontSize: 20,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )),
                  const SizedBox(
                    height: 16,
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
                  GetCustomTextField(
                    controller: amountController,
                    hintTitle: "Enter amount...",
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Details",
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
                    controller: detailsController,
                    hintTitle: "Enter description...",
                    numberOfLines: 3,
                  ),
                  const SizedBox(
                    height: 16,
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
                          .snapshots(),
                      builder: ((context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            PinextCardModel pinextCardModel =
                                PinextCardModel.fromMap(
                              snapshot.data!.docs[index].data(),
                            );

                            String color = pinextCardModel.color;
                            late Color cardColor = getColorFromString(color);

                            return GestureDetector(
                              onTap: () {
                                log("tapped");
                                context
                                    .read<AddTransactionsCubit>()
                                    .selectCard(pinextCardModel.cardId);
                              },
                              child: BlocBuilder<AddTransactionsCubit,
                                  AddTransactionsState>(
                                builder: (context, state) {
                                  return PinextCard(
                                    title: pinextCardModel.title,
                                    balance: pinextCardModel.balance,
                                    cardColor: cardColor,
                                    isSelected: state.selectedCardNo ==
                                        pinextCardModel.cardId,
                                  );
                                },
                              ),
                            );
                          }),
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
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: BlocConsumer<AddTransactionsCubit, AddTransactionsState>(
                listener: (context, state) {
                  if (state is AddTransactionsSuccessState) {
                    Navigator.pop(context);

                    GetCustomSnackbar(
                      title: "Transaction added!!",
                      message: "Your transaction data has been stored.",
                      snackbarType: SnackbarType.success,
                      context: context,
                    );
                  }
                  if (state is AddTransactionsErrorState) {
                    GetCustomSnackbar(
                      title: "Snap",
                      message: state.errorMessage,
                      snackbarType: SnackbarType.error,
                      context: context,
                    );
                    context.read<AddTransactionsCubit>().reset();
                  }
                },
                builder: (context, state) {
                  return GetCustomButton(
                    title: "Add Transaction",
                    titleColor: whiteColor,
                    buttonColor: customBlueColor,
                    isLoading:
                        state is AddTransactionsLoadingState ? true : false,
                    callBackFunction: () {
                      if (amountController.text.isNotEmpty &&
                          detailsController.text.isNotEmpty &&
                          state.selectedCardNo != "none") {
                        context.read<AddTransactionsCubit>().addTransaction(
                              amount: amountController.text,
                              details: detailsController.text,
                              transctionType: state.selectedTransactionMode ==
                                      SelectedTransactionMode.enpense
                                  ? "Expense"
                                  : "Income",
                            );
                      } else {
                        GetCustomSnackbar(
                          title: "Error",
                          message: "Please fill up the form and try again",
                          snackbarType: SnackbarType.error,
                          context: context,
                        );
                      }
                    },
                  );
                },
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