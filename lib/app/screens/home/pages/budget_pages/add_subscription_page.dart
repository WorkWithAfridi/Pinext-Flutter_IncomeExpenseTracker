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
      titleController.text = widget.subscriptionModel!.title;
      descriptionController.text = widget.subscriptionModel!.description;
      amountController.text = widget.subscriptionModel!.amount;
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
          listener: ((context, state) async {
            if (state is AddSubscriptionSuccessState) {
              context.read<UserBloc>().add(RefreshUserStateEvent());
              Navigator.pop(context);
              GetCustomSnackbar(
                title: "Subscription added!!",
                message: "A new subscription has been added!",
                snackbarType: SnackbarType.success,
                context: context,
              );
            } else if (state is AddSubscriptionErrorState) {
              GetCustomSnackbar(
                title: "Snap",
                message: "An error occurred while trying to add your subscription.",
                snackbarType: SnackbarType.error,
                context: context,
              );
              context.read<AddSubscriptionCubit>().resetState();
            } else if (state is SubscriptionFailedToUpdateState) {
              GetCustomSnackbar(
                title: "Snap",
                message: "An error occurred while updating your subscrition. :(",
                snackbarType: SnackbarType.error,
                context: context,
              );
            } else if (state is SubscriptionSuccessfullyUpdatedState) {
              context.read<UserBloc>().add(RefreshUserStateEvent());
              Navigator.pop(context);
              GetCustomSnackbar(
                title: "Updated",
                message: "Your subscription has been updated!",
                snackbarType: SnackbarType.success,
                context: context,
              );
            }
          }),
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
                          "Title *",
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
                          hintTitle: "Ex: Netflix subscription",
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
                          isEnabled: !widget.isEdit,
                          numberOfLines: 4,
                          controller: descriptionController,
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
                          "Amount *",
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
                          numberOfLines: 1,
                          controller: amountController,
                          hintTitle: "Ex: 1200",
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
                              "Automatically add transaction",
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
                                  "Enabling this option will automatically deduct the subscription amount at the start of every month, from the selected card!",
                            ),
                          ],
                        ),
                        BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
                          builder: (context, state) {
                            return Switch(
                              value: state.automaticallyPayActivated,
                              activeColor: customBlueColor,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          !widget.isEdit ? "Select card *" : "Selected card",
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
                  widget.isEdit ? const SizedBox.shrink() : const _GetAlreadyPaidWidget(),
                  widget.isEdit
                      ? widget.subscriptionModel!.lastPaidOn.substring(5, 7) == currentMonth
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Status",
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
                                    title: "Marked as paid",
                                    titleColor: whiteColor,
                                    buttonColor: customBlueColor,
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
                                    "Status",
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
                                    title: "Mark as paid and add transaction to archive",
                                    titleColor: whiteColor,
                                    buttonColor: customBlueColor,
                                    callBackFunction: () {
                                      PinextSubscriptionModel updatedSubscriptionModel = widget.subscriptionModel!;
                                      updatedSubscriptionModel.lastPaidOn = DateTime.now().toString();
                                      context.read<AddSubscriptionCubit>().updateSubscription(
                                            updatedSubscriptionModel,
                                            true,
                                          );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  GetCustomButton(
                                    title: "Mark as paid",
                                    titleColor: whiteColor,
                                    buttonColor: customBlueColor,
                                    callBackFunction: () {
                                      PinextSubscriptionModel updatedSubscriptionModel = widget.subscriptionModel!;
                                      updatedSubscriptionModel.lastPaidOn = DateTime.now().toString();
                                      context.read<AddSubscriptionCubit>().updateSubscription(
                                            updatedSubscriptionModel,
                                            false,
                                          );
                                    },
                                  ),
                                ],
                              ),
                            )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 12,
                  ),
                  widget.isEdit
                      ? const SizedBox.shrink()
                      : _SaveButton(
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
            "Already paid? *",
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                        "Have you already added this transaction into PINEXT Archive for ${months[int.parse(currentMonth) - 1]}  ?",
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
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              context.read<AddSubscriptionCubit>().changeAlreadyPaidStatus("NO");
                            },
                            child: Container(
                              height: kToolbarHeight - 8,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                ),
                                color: state.alreadyPaid == "NO" ? Colors.red[200] : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  defaultBorder,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "NO",
                                style: boldTextStyle.copyWith(
                                  color: state.alreadyPaid == "NO" ? whiteColor : Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              context.read<AddSubscriptionCubit>().changeAlreadyPaidStatus("YES");
                            },
                            child: Container(
                              height: kToolbarHeight - 8,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: customBlueColor,
                                ),
                                color:
                                    state.alreadyPaid == "YES" ? customBlueColor.withOpacity(.5) : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  defaultBorder,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "YES",
                                style: boldTextStyle.copyWith(
                                  color: state.alreadyPaid == "YES" ? whiteColor : customBlueColor,
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
                      .collection("pinext_users")
                      .doc(FirebaseServices().getUserId())
                      .collection("pinext_cards")
                      .where(
                        'cardId',
                        isEqualTo: subscriptionModel!.assignedCardId,
                      )
                      .snapshots()
                  : FirebaseServices()
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
                  return SizedBox(
                    width: getWidth(context) - defaultPadding,
                    child: Center(
                      child: Text(
                        "No card found!",
                        style: regularTextStyle.copyWith(
                          color: Colors.black.withOpacity(
                            .5,
                          ),
                        ),
                      ),
                    ),
                  );
                }
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
                        if (!isEdit) {
                          context.read<AddSubscriptionCubit>().selectCard(pinextCardModel.cardId);
                        }
                      },
                      child: PinextCard(
                        title: pinextCardModel.title,
                        balance: pinextCardModel.balance,
                        cardColor: cardColor,
                        isSelected: addSubscriptionState.selectedCardNo == pinextCardModel.cardId,
                        lastTransactionDate: pinextCardModel.lastTransactionData,
                        cardDetails: pinextCardModel.description,
                        // cardModel: pinextCardModel,
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
            title: "Save Subscription",
            titleColor: whiteColor,
            isLoading: state is AddSubscriptionLoadingState,
            buttonColor: customBlueColor,
            callBackFunction: () {
              if (demoState is DemoDisabledState) {
                if (formKey.currentState!.validate() && state.alreadyPaid != "" && state.selectedCardNo != "") {
                  String title = titleController.text;
                  String description = descriptionController.text;
                  String amount = amountController.text;
                  bool isAutomaticallyPayEnabled = state.automaticallyPayActivated;

                  var date = DateTime.now();
                  var lastMonthDate = "";
                  if (date.month - 1 <= 0) {
                    lastMonthDate = DateTime(date.year - 1, 12, date.day).toString();
                  } else {
                    lastMonthDate = DateTime(date.year, date.month - 1, date.day).toString();
                  }
                  String lastPaidOn = state.alreadyPaid == "YES" ? date.toString() : lastMonthDate.toString();

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
                          transactionId: "",
                        ),
                      );
                } else {
                  GetCustomSnackbar(
                    title: "ERROR",
                    message: "Please input all the required fields and try again!",
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
