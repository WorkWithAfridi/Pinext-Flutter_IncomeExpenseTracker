import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';

import '../../app_data/app_constants/constants.dart';
import '../../bloc/userBloc/user_bloc.dart';
import '../../models/pinext_card_model.dart';
import '../../services/firebase_services.dart';
import '../../shared/widgets/pinext_card.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({
    Key? key,
    this.isAQuickAction = false,
  }) : super(key: key);
  bool isAQuickAction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTransactionsCubit(),
      child: AddTransactionView(
        isAQuickAction: isAQuickAction,
      ),
    );
  }
}

class AddTransactionView extends StatefulWidget {
  AddTransactionView({
    Key? key,
    this.isAQuickAction = false,
  }) : super(key: key);
  bool isAQuickAction;

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

  List listOfTransactionDetailSuggestions = [
    'donation',
    'breakfast',
    'lunch',
    'dinner',
    'date',
    'bus fare',
    'transportation fare',
    'drinks',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (widget.isAQuickAction) {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else {
                context.read<UserBloc>().add(RefreshUserStateEvent());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ROUTES.getHomeframeRoute,
                  (route) => false,
                );
              }
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.close),
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
                  CustomTextFormField(
                    controller: amountController,
                    hintTitle: "Enter amount...",
                    textInputType: TextInputType.number,
                    onChanged: () {},
                    validator: () {
                      return () {};
                    },
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
                  CustomTextFormField(
                    controller: detailsController,
                    hintTitle: "Enter description...",
                    numberOfLines: 3,
                    onChanged: (String value) {
                      context
                          .read<AddTransactionsCubit>()
                          .changeSelectedDescription(value);
                    },
                    validator: () {
                      return () {};
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Suggestions",
                    style: boldTextStyle.copyWith(
                      color: customBlackColor.withOpacity(
                        .6,
                      ),
                    ),
                  ),
                  BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
                    builder: (context, state) {
                      return Wrap(
                        spacing: 5,
                        runSpacing: -8,
                        children: [
                          ...List.generate(
                            listOfTransactionDetailSuggestions.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  String selectedDescription =
                                      listOfTransactionDetailSuggestions[index]
                                          .toString();
                                  log(selectedDescription);
                                  log(state.selectedDescription);
                                  if (state.selectedDescription !=
                                      selectedDescription) {
                                    detailsController.text =
                                        selectedDescription;
                                    context
                                        .read<AddTransactionsCubit>()
                                        .changeSelectedDescription(
                                            selectedDescription);
                                  } else {
                                    context
                                        .read<AddTransactionsCubit>()
                                        .changeSelectedDescription("none");
                                  }
                                },
                                child: Chip(
                                  label: Text(
                                    listOfTransactionDetailSuggestions[index]
                                        .toString(),
                                    style: regularTextStyle.copyWith(
                                      color: listOfTransactionDetailSuggestions[
                                                  index] ==
                                              state.selectedDescription
                                          ? whiteColor
                                          : customBlackColor.withOpacity(.6),
                                    ),
                                  ),
                                  backgroundColor:
                                      listOfTransactionDetailSuggestions[
                                                  index] ==
                                              state.selectedDescription
                                          ? customBlueColor
                                          : greyColor,
                                ),
                              );
                            },
                          ).toList(),
                        ],
                      );
                    },
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
                    if (widget.isAQuickAction) {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else {
                        context.read<UserBloc>().add(RefreshUserStateEvent());
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          ROUTES.getHomeframeRoute,
                          (route) => false,
                        );
                        GetCustomSnackbar(
                          title: "Transaction added!!",
                          message: "Your transaction data has been stored.",
                          snackbarType: SnackbarType.success,
                          context: context,
                        );
                      }
                    } else {
                      context.read<UserBloc>().add(RefreshUserStateEvent());
                      Navigator.pop(context);
                      GetCustomSnackbar(
                        title: "Transaction added!!",
                        message: "Your transaction data has been stored.",
                        snackbarType: SnackbarType.success,
                        context: context,
                      );
                    }
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
