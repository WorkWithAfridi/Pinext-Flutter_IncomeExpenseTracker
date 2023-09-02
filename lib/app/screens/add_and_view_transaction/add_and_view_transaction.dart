import 'dart:developer';
import 'dart:io';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/delete_transaction_cubit/delete_transaction_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/screens/add_and_view_transaction/widgets/add_transaction_button_widget.dart';
import 'package:pinext/app/screens/add_and_view_transaction/widgets/get_card_list_for_add_transactions.dart';
import 'package:pinext/app/screens/add_and_view_transaction/widgets/get_selecte_transaction_type_widget.dart';
import 'package:pinext/app/screens/add_and_view_transaction/widgets/get_tag_list_widget.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';

class AddAndViewTransactionScreen extends StatelessWidget {
  AddAndViewTransactionScreen({
    super.key,
    this.isAQuickAction = false,
    this.isViewOnly = false,
    this.pinextTransactionModel,
  });

  bool isAQuickAction;
  bool isViewOnly;
  PinextTransactionModel? pinextTransactionModel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddTransactionsCubit(),
        ),
        BlocProvider(
          create: (context) => DeleteTransactionCubit(),
        ),
      ],
      child: AddAndViewTransactionView(
        isAQuickAction: isAQuickAction,
        isViewOnly: isViewOnly,
        pinextTransactionModel: pinextTransactionModel,
      ),
    );
  }
}

class AddAndViewTransactionView extends StatefulWidget {
  AddAndViewTransactionView({
    required this.isAQuickAction,
    required this.isViewOnly,
    required this.pinextTransactionModel,
    super.key,
  });

  bool isAQuickAction;
  bool isViewOnly;
  PinextTransactionModel? pinextTransactionModel;

  @override
  State<AddAndViewTransactionView> createState() => _AddAndViewTransactionViewState();
}

class _AddAndViewTransactionViewState extends State<AddAndViewTransactionView> {
  late TextEditingController amountController;
  late TextEditingController detailsController;
  late DateTime transactionDate;

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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    amountController = TextEditingController();
    detailsController = TextEditingController();
    if (widget.isViewOnly) {
      amountController.text = widget.pinextTransactionModel!.amount;
      detailsController.text = widget.pinextTransactionModel!.details;
      if (widget.pinextTransactionModel!.transactionType == 'Income') {
        context.read<AddTransactionsCubit>().changeSelectedTransactionMode(SelectedTransactionMode.income);
      } else {
        context.read<AddTransactionsCubit>().changeSelectedTransactionMode(SelectedTransactionMode.enpense);
      }

      context.read<AddTransactionsCubit>().selectCard(widget.pinextTransactionModel!.cardId);
    }
    context.read<DeleteTransactionCubit>().onResetState();
    super.initState();
  }

  BlocBuilder<AddTransactionsCubit, AddTransactionsState> ChooseIfmarkAsOrNot() {
    return BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 6,
                    ),
                    Checkbox(
                      value: state.markAs,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        context.read<AddTransactionsCubit>().togglemarkAs(value);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<AddTransactionsCubit>().togglemarkAs(state.markAs);
                      },
                      child: RichText(
                        text: TextSpan(
                          // style: DefaultTextStyle.of(context).style,
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(
                              .6,
                            ),
                          ),

                          children: [
                            const TextSpan(
                              text: 'mark as ',
                            ),
                            TextSpan(
                              text: state.selectedTransactionMode == SelectedTransactionMode.income ? 'INCOME' : 'EXPENSE',
                              style: boldTextStyle.copyWith(
                                color: state.selectedTransactionMode == SelectedTransactionMode.income ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: InfoWidget(
                    infoText:
                        "Marking this transaction as an ${state.selectedTransactionMode == SelectedTransactionMode.income ? "income" : "expense"} will contribute the transaction amount towards your monthly, weekly & daily ${state.selectedTransactionMode == SelectedTransactionMode.income ? "budget goals" : "budget"}.",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

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
                context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
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
          icon: const Icon(
            Icons.close,
            color: customBlackColor,
          ),
        ),
        title: Text(
          widget.isViewOnly ? 'Transaction details' : 'Adding a new transaction',
          style: regularTextStyle,
        ),
        actions: [
          if (widget.isViewOnly)
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await CardHandler().getUserCards();
                    await CardHandler().getCardData(widget.pinextTransactionModel!.cardId).then((cardModel) {
                      log(cardModel.toString());
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: Text(
                              'Delete transaction?',
                              style: boldTextStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text(
                                    'Before proceeding with the deletion of this transaction from your pinext account, kindly confirm your decision. It is essential to note that deleting a transaction will result in a corresponding adjustment of the transaction amount associated with the assigned card number. Thank you for your attention to this matter.',
                                    style: regularTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(defaultBorder),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: boldTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(
                                      .8,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Approve'),
                                onPressed: () {
                                  log(cardModel.toString());
                                  context.read<DeleteTransactionCubit>().deleteTransaction(
                                        transactionModel: widget.pinextTransactionModel!,
                                        cardModel: cardModel,
                                      );
                                  Navigator.pop(context);
                                  // Navigator.pop(dialogContext);
                                },
                              ),
                            ],
                            actionsPadding: dialogButtonPadding,
                          );
                        },
                      );
                    });
                  },
                  icon: const Icon(
                    AntIcons.deleteOutlined,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
              ],
            ),
        ],
      ),
      body: BlocListener<DeleteTransactionCubit, DeleteTransactionState>(
        listener: (context, state) {
          if (state is TransactionDeletedSuccessfully) {
            Navigator.pop(context);
            showToast(
              title: 'Transaction deleted!!',
              message: 'Your transaction data has been deleted.',
              snackbarType: SnackbarType.success,
              context: context,
            );
            context.read<UserBloc>().add(RefreshUserStateEvent(context: context));

            final date = DateTime.parse(widget.pinextTransactionModel!.transactionDate);
            final month = date.month.toString().length == 1 ? '0${date.month}' : date.month.toString();

            if (month == currentMonth && date.year.toString() == currentYear) {
              context.read<ArchiveCubit>().getCurrentMonthTransactionArchive(context);
            }
          } else if (state is TransactionNotDeleted) {
            showToast(
              title: 'ERROR',
              message: state.errorMessage,
              snackbarType: SnackbarType.error,
              context: context,
            );
            Future.delayed(const Duration(seconds: 1)).then((_) {
              context.read<DeleteTransactionCubit>().onResetState();
            });
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          GetSelectTransactionTypeWidget(isViewOnly: widget.isViewOnly),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    if (widget.isViewOnly)
                      const SizedBox.shrink()
                    else
                      Column(
                        children: [
                          ChooseIfmarkAsOrNot(),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount',
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
                            isEnabled: !widget.isViewOnly,
                            controller: amountController,
                            hintTitle: 'Enter amount...',
                            textInputType: TextInputType.number,
                            onChanged: (String value) {},
                            validator: (String value) {
                              return InputValidation(value).isCorrectNumber();
                            },
                            suffixButtonAction: () {},
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Details',
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
                            isEnabled: !widget.isViewOnly,
                            controller: detailsController,
                            hintTitle: 'Enter description...',
                            numberOfLines: 3,
                            onChanged: (String value) {
                              context.read<AddTransactionsCubit>().changeSelectedDescription(value);
                            },
                            validator: (String value) {
                              return InputValidation(value).isNotEmpty();
                            },
                            suffixButtonAction: () {},
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Transaction date:',
                                    style: boldTextStyle.copyWith(
                                      color: customBlackColor.withOpacity(
                                        .6,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!widget.isViewOnly) {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                        );
                                        if (picked != null) {
                                          context.read<AddTransactionsCubit>().updateEntryDate(picked);
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[100],
                                      ),
                                      child: widget.isViewOnly
                                          ? Text(
                                              widget.pinextTransactionModel!.transactionDate.substring(0, 10).replaceAll('-', ' / '),
                                              style: boldTextStyle.copyWith(
                                                color: primaryColor.withOpacity(
                                                  .95,
                                                ),
                                              ),
                                            )
                                          : BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
                                              builder: (context, state) {
                                                return Text(
                                                  state.transactionDate.toString().substring(0, 10).replaceAll('-', ' / '),
                                                  style: boldTextStyle.copyWith(
                                                    color: primaryColor.withOpacity(
                                                      .95,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                          if (widget.isViewOnly && widget.pinextTransactionModel!.transactionTag != '')
                            Column(
                              children: [
                                GetTagsList(isViewOnly: widget.isViewOnly, pinextTransactionModel: widget.pinextTransactionModel),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            )
                          else
                            const SizedBox.shrink(),
                          if (!widget.isViewOnly)
                            Column(
                              children: [
                                GetTagsList(isViewOnly: widget.isViewOnly, pinextTransactionModel: widget.pinextTransactionModel),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          if (widget.isViewOnly)
                            Text(
                              'Card',
                              style: boldTextStyle.copyWith(
                                color: customBlackColor.withOpacity(
                                  .6,
                                ),
                              ),
                            )
                          else
                            Text(
                              'Select card',
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
                  ],
                ),
                GetCardListForAddTransaction(
                  isViewOnly: widget.isViewOnly,
                  viewTransactionModel: widget.pinextTransactionModel,
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isViewOnly)
                  const SizedBox.shrink()
                else
                  AddTransactionButtonWidget(
                    isAQuickAction: widget.isAQuickAction,
                    isViewOnly: widget.isViewOnly,
                    amountController: amountController,
                    detailsController: detailsController,
                    formKey: _formKey,
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
