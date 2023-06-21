import 'dart:developer';
import 'dart:io';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/routing/routes.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_transactions_cubit/add_transactions_cubit.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/delete_transaction_cubit/delete_transaction_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';

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

  Column SelectTransactionTypeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction type',
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
          child: BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
            builder: (context, state) {
              return Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        if (!widget.isViewOnly) {
                          context.read<AddTransactionsCubit>().changeSelectedTransactionMode(SelectedTransactionMode.income);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultBorder),
                            color: state.selectedTransactionMode == SelectedTransactionMode.income ? greyColor : Colors.transparent,
                          ),
                          child: Text(
                            'Deposit',
                            style: state.selectedTransactionMode == SelectedTransactionMode.income
                                ? boldTextStyle.copyWith(
                                    color: primaryColor,
                                    fontSize: 20,
                                  )
                                : boldTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.4),
                                    fontSize: 20,
                                  ),
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
                    child: GestureDetector(
                      onTap: () {
                        if (!widget.isViewOnly) {
                          context.read<AddTransactionsCubit>().changeSelectedTransactionMode(SelectedTransactionMode.enpense);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultBorder),
                            color: state.selectedTransactionMode == SelectedTransactionMode.enpense ? greyColor : Colors.transparent,
                          ),
                          child: Text(
                            'Withdrawal ',
                            style: state.selectedTransactionMode == SelectedTransactionMode.enpense
                                ? boldTextStyle.copyWith(
                                    color: primaryColor,
                                    fontSize: 20,
                                  )
                                : boldTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(.4),
                                    fontSize: 20,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Column GetSuggestionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions',
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
                        final selectedDescription = listOfTransactionDetailSuggestions[index].toString();
                        if (state.selectedDescription != selectedDescription) {
                          detailsController.text = selectedDescription;
                          context.read<AddTransactionsCubit>().changeSelectedDescription(selectedDescription);
                        } else {
                          context.read<AddTransactionsCubit>().changeSelectedDescription('none');
                        }
                      },
                      child: Chip(
                        label: Text(
                          listOfTransactionDetailSuggestions[index].toString(),
                          style: regularTextStyle.copyWith(
                            color: listOfTransactionDetailSuggestions[index] == state.selectedDescription ? whiteColor : customBlackColor.withOpacity(.6),
                          ),
                        ),
                        backgroundColor: listOfTransactionDetailSuggestions[index] == state.selectedDescription ? primaryColor : greyColor,
                      ),
                    );
                  },
                ).toList(),
              ],
            );
          },
        ),
      ],
    );
  }

  Column GetTagsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: boldTextStyle.copyWith(
            color: customBlackColor.withOpacity(
              .6,
            ),
          ),
        ),
        BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
          builder: (context, state) {
            if (widget.isViewOnly) {
              return Chip(
                label: Text(
                  widget.pinextTransactionModel!.transactionTag,
                  style: regularTextStyle.copyWith(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: primaryColor,
              );
            }
            return Wrap(
              spacing: 5,
              runSpacing: -8,
              children: [
                ...List.generate(
                  transactionTags.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        final selectedTag = transactionTags[index];
                        if (state.selectedTag != selectedTag) {
                          context.read<AddTransactionsCubit>().changeSelectedTag(selectedTag);
                        } else {
                          context.read<AddTransactionsCubit>().changeSelectedTag('');
                        }
                      },
                      child: Chip(
                        label: Text(
                          transactionTags[index],
                          style: regularTextStyle.copyWith(
                            color: transactionTags[index] == state.selectedTag ? whiteColor : customBlackColor.withOpacity(.6),
                            fontWeight: transactionTags[index] == state.selectedTag ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        backgroundColor: transactionTags[index] == state.selectedTag ? primaryColor : greyColor,
                      ),
                    );
                  },
                ).toList(),
              ],
            );
          },
        ),
      ],
    );
  }

  Padding AddTransactionButton() {
    return Padding(
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
                context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
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
              context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
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
            title: widget.isViewOnly ? 'Update Transaction' : 'Add Transaction',
            titleColor: whiteColor,
            buttonColor: primaryColor,
            isLoading: state is AddTransactionsLoadingState ? true : false,
            callBackFunction: () {
              if (demoBlocState is DemoDisabledState) {
                if (_formKey.currentState!.validate()) {
                  if (amountController.text.isNotEmpty && detailsController.text.isNotEmpty && state.selectedCardNo != 'none' && state.selectedTag != '') {
                    if (widget.isViewOnly) {
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
                        if (widget.isAQuickAction) {
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
                )
              ],
            )
        ],
      ),
      body: BlocListener<DeleteTransactionCubit, DeleteTransactionState>(
        listener: (context, state) {
          if (state is TransactionDeletedSuccessfully) {
            Navigator.pop(context);
            GetCustomSnackbar(
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
            GetCustomSnackbar(
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
                          SelectTransactionTypeCard(),
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
                            height: 12,
                          ),
                          if (widget.isViewOnly && widget.pinextTransactionModel!.transactionTag != '')
                            Column(
                              children: [
                                GetTagsList(),
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
                                GetTagsList(),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            )
                          else
                            const SizedBox.shrink(),
                          // Column(
                          //   children: [
                          //     GetTagsList(),
                          //     const SizedBox(
                          //       height: 12,
                          //     ),
                          //   ],
                          // ),
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
                _GetCardListWidget(
                  isViewOnly: widget.isViewOnly,
                  viewTransactionModel: widget.pinextTransactionModel,
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isViewOnly) const SizedBox.shrink() else AddTransactionButton(),
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

class _GetCardListWidget extends StatelessWidget {
  _GetCardListWidget({
    required this.isViewOnly,
    this.viewTransactionModel,
  });

  bool isViewOnly;
  PinextTransactionModel? viewTransactionModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getCardHeight(context) + 10,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(
              width: defaultPadding,
            ),
            StreamBuilder(
              stream: isViewOnly
                  ? FirebaseServices()
                      .firebaseFirestore
                      .collection('pinext_users')
                      .doc(FirebaseServices().getUserId())
                      .collection('pinext_cards')
                      .where('cardId', isEqualTo: viewTransactionModel!.cardId)
                      .snapshots()
                  : FirebaseServices()
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
                  return SizedBox(
                    width: getWidth(context) - defaultPadding,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    width: getWidth(context) - defaultPadding * 2,
                    alignment: Alignment.center,
                    child: Text(
                      'Please add a Pinext card to view your cards list here.',
                      style: regularTextStyle.copyWith(
                        color: customBlackColor.withOpacity(.4),
                      ),
                      maxLines: 3,
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final pinextCardModel = PinextCardModel.fromMap(
                      snapshot.data!.docs[index].data(),
                    );

                    final color = pinextCardModel.color;
                    late final cardColor = getColorFromString(color);

                    return BlocBuilder<AddTransactionsCubit, AddTransactionsState>(
                      builder: (context, state) {
                        final Widget pinextCardWidget = GestureDetector(
                          onTap: () {
                            if (!isViewOnly) {
                              if (state.selectedCardNo == pinextCardModel.cardId) {
                                context.read<AddTransactionsCubit>().selectCard('none');
                              } else {
                                context.read<AddTransactionsCubit>().selectCard(pinextCardModel.cardId);
                              }
                            }
                          },
                          child: PinextCard(
                            title: pinextCardModel.title,
                            balance: pinextCardModel.balance,
                            cardColor: pinextCardModel.color,
                            isSelected: isViewOnly ? false : state.selectedCardNo == pinextCardModel.cardId,
                            lastTransactionDate: pinextCardModel.lastTransactionData,
                            cardDetails: pinextCardModel.description,
                            cardId: pinextCardModel.cardId,
                            // cardModel: pinextCardModel,
                            // cardModel: pinextCardModel,
                          ),
                        );
                        return pinextCardWidget;
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(
              width: defaultPadding - 10,
            ),
          ],
        ),
      ),
    );
  }
}
