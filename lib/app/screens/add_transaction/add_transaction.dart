import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';

import '../../app_data/app_constants/constants.dart';

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
                    child:
                        BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
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
                GetCustomButton(
                  title: "Add Transaction",
                  titleColor: whiteColor,
                  buttonColor: customBlueColor,
                  callBackFunction: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
