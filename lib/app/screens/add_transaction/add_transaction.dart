import 'dart:developer';
import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';

import '../../app_data/app_constants/constants.dart';
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

class AddTransactionView extends StatelessWidget {
  const AddTransactionView({Key? key}) : super(key: key);

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
          "Adding new Transaction",
          style: regularTextStyle,
        ),
      ),
      body: Column(
        children: [
          Column(
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
                      controller: TextEditingController(),
                      hintTitle: "Enter amount...",
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
                      controller: TextEditingController(),
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
                      BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
                        builder: (context, state) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: ((context, index) {
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<AddTransactionsCubit>()
                                      .selectCard(index.toString());
                                },
                                child: PinextCard(
                                  isSelected:
                                      state.selectedCardNo == index.toString(),
                                ),
                              );
                            }),
                          );
                        },
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
                    log("rebuilding");
                    if (state is AddTransactionsSuccessState) {
                      Navigator.pop(context);
                      ElegantNotification.success(
                        title: Text(
                          "Transaction added!!",
                          style: boldTextStyle,
                        ),
                        description: Text(
                          "Your transaction data has been stored.",
                          style: regularTextStyle,
                        ),
                        width: getWidth(context) * .9,
                        animationDuration: const Duration(milliseconds: 200),
                        toastDuration: const Duration(seconds: 5),
                      ).show(context);
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
                        context.read<AddTransactionsCubit>().addTransaction();
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
