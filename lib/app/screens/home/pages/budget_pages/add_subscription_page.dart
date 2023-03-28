import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_subscription_cubit/add_subscription_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_subscription_model.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';
import 'package:uuid/uuid.dart';

class AddSubscriptionPage extends StatelessWidget {
  AddSubscriptionPage({
    super.key,
    this.isEdit = false,
    this.subscriptionModel,
  });
  bool isEdit;
  PinextSubscriptionModel? subscriptionModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddSubscriptionCubit(),
      child: AddSubscriptionView(
        isEdit: isEdit,
        subscriptionModel: subscriptionModel,
      ),
    );
  }
}

class AddSubscriptionView extends StatefulWidget {
  AddSubscriptionView({
    super.key,
    this.isEdit = false,
    this.subscriptionModel,
  });
  bool isEdit;
  PinextSubscriptionModel? subscriptionModel;

  @override
  State<AddSubscriptionView> createState() => _AddSubscriptionViewState();
}

class _AddSubscriptionViewState extends State<AddSubscriptionView> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit) {
      final demoState = context.read<DemoBloc>().state;
      titleController.text = demoState is DemoEnabledState ? 'Subscription name' : widget.subscriptionModel!.title;
      descriptionController.text = demoState is DemoEnabledState ? 'a natural looking block of text.' : widget.subscriptionModel!.description;
      amountController.text = demoState is DemoEnabledState ? '1000' : widget.subscriptionModel!.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      final addSubscriptionCubit = context.read<AddSubscriptionCubit>().state;
      addSubscriptionCubit.automaticallyPayActivated = widget.subscriptionModel!.automaticallyDeductEnabled;
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<AddSubscriptionCubit, AddSubscriptionState>(
          listener: (context, state) async {
            if (state is AddSubscriptionSuccessState) {
              context.read<UserBloc>().add(RefreshUserStateEvent());
              Navigator.pop(context);
              GetCustomSnackbar(
                title: 'Subscription added!!',
                message: 'A new subscription has been added!',
                snackbarType: SnackbarType.success,
                context: context,
              );
            } else if (state is AddSubscriptionErrorState) {
              GetCustomSnackbar(
                title: 'Snap',
                message: 'An error occurred while trying to add your subscription.',
                snackbarType: SnackbarType.error,
                context: context,
              );
              context.read<AddSubscriptionCubit>().resetState();
            } else if (state is SubscriptionFailedToUpdateState) {
              GetCustomSnackbar(
                title: 'Snap',
                message: state.errorMessage,
                snackbarType: SnackbarType.error,
                context: context,
              );
              context.read<AddSubscriptionCubit>().resetState();
            } else if (state is SubscriptionSuccessfullyUpdatedState) {
              context.read<UserBloc>().add(RefreshUserStateEvent());
              Navigator.pop(context);
              GetCustomSnackbar(
                title: 'Updated',
                message: 'Your subscription has been updated!',
                snackbarType: SnackbarType.success,
                context: context,
              );
            } else if (state is DeletedSubscriptionSuccessState) {
              Navigator.pop(context);
              GetCustomSnackbar(
                title: 'Deleted',
                message: 'Your subscription has been deleted.',
                snackbarType: SnackbarType.info,
                context: context,
              );
              context.read<AddSubscriptionCubit>().resetState();
            }
          },
        ),
      ],
      child: Scaffold(
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
            'Adding a new subscription',
            style: regularTextStyle,
          ),
          actions: [
            if (widget.isEdit)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: Text(
                              'Delete subscription?',
                              style: boldTextStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text(
                                    "You're about to delete this subscription from your pinext account! Are you sure you want to do that??",
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
                                  context.read<AddSubscriptionCubit>().deleteGoal(widget.subscriptionModel!);
                                  Navigator.pop(dialogContext);
                                },
                              ),
                            ],
                            actionsPadding: dialogButtonPadding,
                          );
                        },
                      );
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
              )
            else
              const SizedBox.shrink()
          ],
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
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Title *',
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
                          isEnabled: !widget.isEdit,
                          controller: titleController,
                          hintTitle: 'Ex: Netflix subscription',
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
                          'Description',
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
                          isEnabled: !widget.isEdit,
                          numberOfLines: 4,
                          controller: descriptionController,
                          hintTitle: '',
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
                          'Amount *',
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
                          isEnabled: !widget.isEdit,
                          controller: amountController,
                          hintTitle: 'Ex: 1200',
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
                  const SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                      left: defaultPadding,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Automatically add transaction',
                              style: boldTextStyle.copyWith(
                                color: customBlackColor.withOpacity(
                                  .6,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InfoWidget(
                              infoText:
                                  'Enabling this option will automatically deduct the subscription amount at the start of every month, from the selected card!',
                            ),
                          ],
                        ),
                        BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
                          builder: (context, state) {
                            return Switch(
                              value: state.automaticallyPayActivated,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                if (!widget.isEdit) {
                                  context.read<AddSubscriptionCubit>().toogleAutomaticallyPaySwitch(value);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          !widget.isEdit ? 'Select card *' : 'Selected card',
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
                  _GetCardList(
                    isEdit: widget.isEdit,
                    subscriptionModel: widget.subscriptionModel,
                  ),
                  if (widget.isEdit) const SizedBox.shrink() else const _GetAlreadyPaidWidget(),
                  if (widget.isEdit)
                    widget.subscriptionModel!.lastPaidOn.substring(5, 7) == currentMonth
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Status',
                                  style: boldTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(
                                      .6,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                GetCustomButton(
                                  title: 'Marked as paid',
                                  titleColor: whiteColor,
                                  buttonColor: primaryColor,
                                  callBackFunction: () {},
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Status',
                                  style: boldTextStyle.copyWith(
                                    color: customBlackColor.withOpacity(
                                      .6,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
                                  builder: (context, state) {
                                    return GetCustomButton(
                                      title: 'Mark as paid and add transaction to archive',
                                      titleColor: whiteColor,
                                      buttonColor: primaryColor,
                                      isLoading: state is UpdateSubscriptionMarkAsPaidAndAddTransactionButtonLoadingState,
                                      callBackFunction: () {
                                        final demoState = context.read<DemoBloc>().state;
                                        if (demoState is DemoDisabledState) {
                                          final updatedSubscriptionModel = widget.subscriptionModel!;
                                          updatedSubscriptionModel.lastPaidOn = DateTime.now().toString();
                                          context.read<AddSubscriptionCubit>().updateSubscription(
                                                updatedSubscriptionModel,
                                                true,
                                                context,
                                              );
                                        }
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
                                  builder: (context, state) {
                                    return GetCustomButton(
                                      title: 'Mark as paid',
                                      titleColor: whiteColor,
                                      isLoading: state is UpdateSubscriptionMarkAsPaidButtonLoadingState,
                                      buttonColor: primaryColor,
                                      callBackFunction: () {
                                        final demoState = context.read<DemoBloc>().state;
                                        if (demoState is DemoDisabledState) {
                                          final updatedSubscriptionModel = widget.subscriptionModel!;
                                          updatedSubscriptionModel.lastPaidOn = DateTime.now().toString();
                                          context.read<AddSubscriptionCubit>().updateSubscription(
                                                updatedSubscriptionModel,
                                                false,
                                                context,
                                              );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isEdit)
                    const SizedBox.shrink()
                  else
                    _SaveButton(
                      titleController: titleController,
                      descriptionController: descriptionController,
                      amountController: amountController,
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
      ),
    );
  }
}

class _GetAlreadyPaidWidget extends StatelessWidget {
  const _GetAlreadyPaidWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          Text(
            'Already paid? *',
            style: boldTextStyle.copyWith(
              color: customBlackColor.withOpacity(
                .6,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.all(
              defaultPadding,
            ),
            decoration: BoxDecoration(
              color: greyColor,
              borderRadius: BorderRadius.circular(
                defaultBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.money,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        'Have you already added this transaction into PINEXT Archive for ${months[int.parse(currentMonth) - 1]}  ?',
                        style: regularTextStyle.copyWith(
                          color: customBlackColor.withOpacity(
                            .8,
                          ),
                        ),
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              context.read<AddSubscriptionCubit>().changeAlreadyPaidStatus('NO');
                            },
                            child: Container(
                              height: kToolbarHeight - 8,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                ),
                                color: state.alreadyPaid == 'NO' ? Colors.red[200] : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  defaultBorder,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'NO',
                                style: boldTextStyle.copyWith(
                                  color: state.alreadyPaid == 'NO' ? whiteColor : Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              context.read<AddSubscriptionCubit>().changeAlreadyPaidStatus('YES');
                            },
                            child: Container(
                              height: kToolbarHeight - 8,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor,
                                ),
                                color: state.alreadyPaid == 'YES' ? primaryColor.withOpacity(.5) : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  defaultBorder,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'YES',
                                style: boldTextStyle.copyWith(
                                  color: state.alreadyPaid == 'YES' ? whiteColor : primaryColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _GetCardList extends StatelessWidget {
  _GetCardList({
    required this.isEdit,
    required this.subscriptionModel,
  });

  bool isEdit;
  PinextSubscriptionModel? subscriptionModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              stream: isEdit
                  ? FirebaseServices()
                      .firebaseFirestore
                      .collection('pinext_users')
                      .doc(FirebaseServices().getUserId())
                      .collection('pinext_cards')
                      .where(
                        'cardId',
                        isEqualTo: subscriptionModel!.assignedCardId,
                      )
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
                final addSubscriptionState = context.watch<AddSubscriptionCubit>().state;
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

                    return GestureDetector(
                      onTap: () {
                        if (!isEdit) {
                          context.read<AddSubscriptionCubit>().selectCard(pinextCardModel.cardId);
                        }
                      },
                      child: PinextCard(
                        title: pinextCardModel.title,
                        balance: pinextCardModel.balance,
                        cardColor: pinextCardModel.color,
                        isSelected: addSubscriptionState.selectedCardNo == pinextCardModel.cardId,
                        lastTransactionDate: pinextCardModel.lastTransactionData,
                        cardDetails: pinextCardModel.description,
                        cardId: pinextCardModel.cardId,
                        // cardModel: pinextCardModel,
                      ),
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

class _SaveButton extends StatelessWidget {
  _SaveButton({
    required this.titleController,
    required this.descriptionController,
    required this.amountController,
    required this.formKey,
  });

  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController amountController;

  var formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
        builder: (context, state) {
          final demoState = context.watch<DemoBloc>().state;
          return GetCustomButton(
            title: 'Save Subscription',
            titleColor: whiteColor,
            isLoading: state is AddSubscriptionLoadingState,
            buttonColor: primaryColor,
            callBackFunction: () {
              if (demoState is DemoDisabledState) {
                if (formKey.currentState!.validate() as bool && (state.alreadyPaid != '') && (state.selectedCardNo != '')) {
                  final title = titleController.text.toLowerCase();
                  final description = descriptionController.text.toLowerCase();
                  final amount = amountController.text;
                  final isAutomaticallyPayEnabled = state.automaticallyPayActivated;

                  final date = DateTime.now();
                  var lastMonthDate = '';
                  if (date.month - 1 <= 0) {
                    lastMonthDate = DateTime(date.year - 1, 12, date.day).toString();
                  } else {
                    lastMonthDate = DateTime(date.year, date.month - 1, date.day).toString();
                  }
                  final lastPaidOn = state.alreadyPaid == 'YES' ? date.toString() : lastMonthDate.toString();

                  context.read<AddSubscriptionCubit>().addSubscription(
                        PinextSubscriptionModel(
                          dateAdded: DateTime.now().toString(),
                          lastPaidOn: lastPaidOn,
                          amount: amount,
                          subscriptionId: const Uuid().v4(),
                          assignedCardId: state.selectedCardNo,
                          automaticallyDeductEnabled: isAutomaticallyPayEnabled,
                          description: description,
                          title: title,
                          transactionId: '',
                        ),
                      );
                } else {
                  GetCustomSnackbar(
                    title: 'ERROR',
                    message: 'Please input all the required fields and try again!',
                    snackbarType: SnackbarType.error,
                    context: context,
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
