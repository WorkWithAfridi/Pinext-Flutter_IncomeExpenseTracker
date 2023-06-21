import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';

class AddTransactionButtonWidget extends StatelessWidget {
  AddTransactionButtonWidget({
    required this.isAQuickAction,
    required this.isViewOnly,
    required this.amountController,
    required this.detailsController,
    required this.formKey,
    super.key,
  });
  bool isAQuickAction;
  bool isViewOnly;

  TextEditingController amountController;
  TextEditingController detailsController;

  GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: BlocConsumer<AddTransactionsCubit, AddTransactionsState>(
        listener: (context, state) {
          if (state is AddTransactionsSuccessState) {
            if (isAQuickAction) {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ROUTES.getHomeframeRoute,
                  (route) => false,
                );
                GetCustomSnackbar(
                  title: 'Transaction added!!',
                  message: 'Your transaction data has been stored.',
                  snackbarType: SnackbarType.success,
                  context: context,
                );
              }
            } else {
              Navigator.pop(context);
              GetCustomSnackbar(
                title: 'Transaction added!!',
                message: 'Your transaction data has been stored.',
                snackbarType: SnackbarType.success,
                context: context,
              );
            }
          }
          if (state is AddTransactionsErrorState) {
            GetCustomSnackbar(
              title: 'Snap',
              message: state.errorMessage,
              snackbarType: SnackbarType.error,
              context: context,
            );
            context.read<AddTransactionsCubit>().reset();
          }
        },
        builder: (context, state) {
          final demoBlocState = context.watch<DemoBloc>().state;
          return GetCustomButton(
            title: isViewOnly ? 'Update Transaction' : 'Add Transaction',
            titleColor: whiteColor,
            buttonColor: primaryColor,
            isLoading: state is AddTransactionsLoadingState ? true : false,
            callBackFunction: () {
              if (demoBlocState is DemoDisabledState) {
                if (formKey.currentState!.validate()) {
                  if (amountController.text.isNotEmpty && detailsController.text.isNotEmpty && state.selectedCardNo != 'none' && state.selectedTag != '') {
                    if (isViewOnly) {
                      GetCustomSnackbar(
                        title: 'Hello',
                        message: 'This function has not yet been deployed! :)',
                        snackbarType: SnackbarType.info,
                        context: context,
                      );
                    } else {
                      if (state is AddTransactionsLoadingState) {
                        GetCustomSnackbar(
                          title: 'Snap',
                          message: 'A transaction is being processed! Please be patient. :)',
                          snackbarType: SnackbarType.error,
                          context: context,
                        );
                      } else {
                        if (isAQuickAction) {
                          UserHandler().getCurrentUser();
                        }
                        context.read<AddTransactionsCubit>().addTransaction(
                              amount: amountController.text,
                              details: detailsController.text,
                              transctionType: state.selectedTransactionMode == SelectedTransactionMode.enpense ? 'Expense' : 'Income',
                              transctionTag: state.selectedTag,
                              context: context,
                            );
                      }
                    }
                  } else {
                    if (state.selectedCardNo == 'none') {
                      GetCustomSnackbar(
                        title: 'Error',
                        message: 'Please select a valid card and try again!',
                        snackbarType: SnackbarType.error,
                        context: context,
                      );
                    } else if (detailsController.text.isEmpty) {
                      GetCustomSnackbar(
                        title: 'Error',
                        message: 'Please enter valid details of the transaction and try again!',
                        snackbarType: SnackbarType.error,
                        context: context,
                      );
                    } else if (amountController.text.isEmpty) {
                      GetCustomSnackbar(
                        title: 'Error',
                        message: 'Please enter valid amount and try again!',
                        snackbarType: SnackbarType.error,
                        context: context,
                      );
                    } else if (state.selectedTag == '') {
                      GetCustomSnackbar(
                        title: 'Error',
                        message: 'Please enter a valid transaction tag and try again!',
                        snackbarType: SnackbarType.error,
                        context: context,
                      );
                    }
                  }
                }
              }
            },
          );
        },
      ),
    );
  }
}
