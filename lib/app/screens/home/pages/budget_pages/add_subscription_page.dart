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
import 'package:pinext/app/services/handlers/transaction_handler.dart' as transaction;
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';
import 'package:uuid/uuid.dart';

class AddSubscriptionPage extends StatelessWidget {
  const AddSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddSubscriptionCubit(),
      child: AddSubscriptionView(),
    );
  }
}

class AddSubscriptionView extends StatelessWidget {
  AddSubscriptionView({
    super.key,
  });

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              context.read<AddSubscriptionCubit>().toogleAutomaticallyPaySwitch(value);
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
                        "Select card *",
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
                              .orderBy(
                                'lastTransactionData',
                                descending: true,
                              )
                              .snapshots(),
                          builder: ((context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
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
                            return BlocBuilder<AddSubscriptionCubit, AddSubscriptionState>(
                              builder: (cubitContext, state) {
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
                                        cubitContext.read<AddSubscriptionCubit>().selectCard(pinextCardModel.cardId);
                                      },
                                      child: PinextCard(
                                        title: pinextCardModel.title,
                                        balance: pinextCardModel.balance,
                                        cardColor: cardColor,
                                        isSelected: state.selectedCardNo == pinextCardModel.cardId,
                                        lastTransactionDate: pinextCardModel.lastTransactionData,
                                        cardDetails: pinextCardModel.description,
                                        // cardModel: pinextCardModel,
                                      ),
                                    );
                                  }),
                                );
                              },
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
                                    "Have you already added this transaction into PINEXT Archive for ${months[int.parse(currentMonth) - 1]} $currentYear ?",
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
                                            color: state.alreadyPaid == "YES"
                                                ? customBlueColor.withOpacity(.5)
                                                : Colors.transparent,
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
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: BlocConsumer<AddSubscriptionCubit, AddSubscriptionState>(
                    listener: ((context, state) async {
                      if (state is AddSubscriptionSuccessState) {
                        if (state.alreadyPaid == "YES") {
                          await transaction.TransactionHandler().addTransaction(
                            amount: amountController.text,
                            description: titleController.text,
                            transactionType: "Expense",
                            cardId: state.selectedCardNo,
                            markedAs: true,
                          );
                        }
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
                      }
                    }),
                    builder: (context, state) {
                      final demoState = context.watch<DemoBloc>().state;
                      return GetCustomButton(
                        title: "Save Subscription",
                        titleColor: whiteColor,
                        isLoading: state is AddSubscriptionLoadingState,
                        buttonColor: customBlueColor,
                        callBackFunction: () {
                          if (demoState is DemoDisabledState) {
                            if (_formKey.currentState!.validate() &&
                                state.alreadyPaid != "" &&
                                state.selectedCardNo != "") {
                              String title = titleController.text;
                              String description = descriptionController.text;
                              String amount = amountController.text;
                              bool isAutomaticallyPayEnabled = state.automaticallyPayActivated;

                              var date = DateTime.now();
                              var lastMonthDate = DateTime(date.year, date.month - 1, date.day);
                              String lastPaidOn =
                                  state.alreadyPaid == "YES" ? DateTime.now().toString() : lastMonthDate.toString();

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
