import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/bloc/add_card_cubit/add_card_cubit.dart';
import 'package:pinext/app/bloc/cards_and_balances_cubit/cards_and_balances_cubit.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';
import 'package:uuid/uuid.dart';

import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';
import '../../bloc/demoBloc/demo_bloc.dart';
import '../../bloc/signup_cubit/signin_cubit_cubit.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';

class AddAndEditPinextCardScreen extends StatelessWidget {
  AddAndEditPinextCardScreen({
    Key? key,
    this.addCardForSignUpProcess = false,
    this.isEditCardScreen = false,
    this.pinextCardModel,
    this.isDemoMode = false,
  }) : super(key: key);
  bool addCardForSignUpProcess;
  bool isEditCardScreen;
  bool isDemoMode;
  PinextCardModel? pinextCardModel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddCardCubit(),
        ),
      ],
      child: AddAndEditPinextCardView(
        addCardForSignUpProcess: addCardForSignUpProcess,
        isEditCardScreen: isEditCardScreen,
        pinextCardModel: pinextCardModel,
        isDemoMode: isDemoMode,
      ),
    );
  }
}

class AddAndEditPinextCardView extends StatefulWidget {
  AddAndEditPinextCardView({
    Key? key,
    this.addCardForSignUpProcess = false,
    this.isEditCardScreen = false,
    this.isDemoMode = false,
    this.pinextCardModel,
  }) : super(key: key);
  bool addCardForSignUpProcess;
  bool isEditCardScreen;
  bool isDemoMode;
  PinextCardModel? pinextCardModel;

  @override
  State<AddAndEditPinextCardView> createState() => _AddAndEditPinextCardViewState();
}

class _AddAndEditPinextCardViewState extends State<AddAndEditPinextCardView> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController balanceController;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    balanceController = TextEditingController();
    if (widget.isEditCardScreen) {
      titleController.text = widget.isDemoMode ? "Bank" : widget.pinextCardModel!.title.toString();
      descriptionController.text = widget.isDemoMode
          ? "The purpose of lorem ipsum is to create a natural looking block of text (sentence, paragraph, page, etc.) that doesn't distract from the layout."
          : widget.pinextCardModel!.description.toString();
      balanceController.text = widget.isDemoMode ? "55000" : widget.pinextCardModel!.balance.toString();
      isEditCardColor = widget.pinextCardModel!.color;
    }
    super.initState();
  }

  String? isEditCardColor;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log("Rebuilding");
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
          widget.isEditCardScreen ? "Editing Pinext card" : "Adding a new Pinext card",
          style: regularTextStyle,
        ),
      ),
      body: Scrollbar(
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
                      Text(
                        "Card title",
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
                        hintTitle: "Enter title",
                        textInputType: TextInputType.text,
                        onChanged: (String value) {},
                        validator: (value) {
                          return InputValidation(value).isNotEmpty();
                        },
                        suffixButtonAction: () {},
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Card description (if any)",
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
                        controller: descriptionController,
                        hintTitle: "Enter description",
                        numberOfLines: 5,
                        textInputType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        onChanged: (String value) {},
                        validator: (value) {
                          return null;
                        },
                        suffixButtonAction: () {},
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Current balance",
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
                        controller: balanceController,
                        hintTitle: "Enter card balance",
                        textInputType: TextInputType.number,
                        onChanged: (String value) {},
                        validator: (value) {
                          return InputValidation(value).isCorrectNumber();
                        },
                        suffixButtonAction: () {},
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Select card color",
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
                  height: 36,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        ListView.builder(
                          itemCount: listOfCardColors.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            String color = listOfCardColors[index];
                            late Color cardColor = getColorFromString(color);
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<AddCardCubit>().changeColor(color);
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: getWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      BlocConsumer<AddCardCubit, AddCardState>(
                        listener: (context, state) {
                          if (widget.isEditCardScreen) {
                            if (state is AddCardDefaultState) {
                              isEditCardColor = state.color;
                            }
                          }
                        },
                        builder: (context, state) {
                          String color = state.color;
                          late Color cardColor = getColorFromString(color);
                          return PinextCard(
                            cardColor: widget.isEditCardScreen ? getColorFromString(isEditCardColor!) : cardColor,
                            title: widget.isEditCardScreen ? widget.pinextCardModel!.title : "Example card",
                            balance: widget.isEditCardScreen ? widget.pinextCardModel!.balance : 1233456,
                            lastTransactionDate: widget.isEditCardScreen
                                ? widget.pinextCardModel!.lastTransactionData.toString()
                                : DateTime.now().toString(),
                            cardDetails: widget.isEditCardScreen ? widget.pinextCardModel!.description : " ",
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                BlocListener<CardsAndBalancesCubit, CardsAndBalancesState>(
                  listener: (context, state) {
                    if (state is CardsAndBalancesSuccessfullyEditedCardState) {
                      context.read<AddCardCubit>().reset();
                      context.read<CardsAndBalancesCubit>().resetState();
                      Navigator.pop(context);
                      GetCustomSnackbar(
                        title: "Success",
                        message: "Your card details have been updated!!",
                        snackbarType: SnackbarType.success,
                        context: context,
                      );

                      context.read<AddCardCubit>().reset();
                      context.read<CardsAndBalancesCubit>().resetState();
                    }
                    if (state is CardsAndBalancesFailedToEditedCardState) {
                      context.read<AddCardCubit>().reset();
                      context.read<CardsAndBalancesCubit>().resetState();
                      GetCustomSnackbar(
                        title: "Error",
                        message: "Your card details have been updated!!",
                        snackbarType: SnackbarType.success,
                        context: context,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: BlocConsumer<AddCardCubit, AddCardState>(
                      listener: (context, state) {
                        if (widget.isEditCardScreen) {
                          if (state is EditCardErrorState) {
                            GetCustomSnackbar(
                              title: "Error",
                              message: "Sorry! :( Couldnt update your card!",
                              snackbarType: SnackbarType.error,
                              context: context,
                            );
                            // context.read<AddCardCubit>().reset();
                          }
                          if (state is EditCardSuccessState) {
                            PinextCardModel editedCard = PinextCardModel(
                              cardId: widget.pinextCardModel!.cardId,
                              title: titleController.text,
                              description: descriptionController.text,
                              balance: double.parse(balanceController.text),
                              color: state.color,
                              lastTransactionData: widget.pinextCardModel!.lastTransactionData,
                            );
                            context.read<CardsAndBalancesCubit>().updateCard(
                                  editedCard,
                                );
                          }
                        } else {
                          if (state is AddCardErrorState) {
                            GetCustomSnackbar(
                              title: "ERROR :(",
                              message: "An error occurred while trying to add you card, please try again later!",
                              snackbarType: SnackbarType.error,
                              context: context,
                            );
                            context.read<AddCardCubit>().reset();
                          }
                          if (state is AddCardSuccessState) {
                            PinextCardModel newPinextCard = PinextCardModel(
                              cardId: const Uuid().v4().toString(),
                              title: state.title,
                              description: state.description,
                              balance: state.balance,
                              color: state.color,
                              lastTransactionData: DateTime.now().toString(),
                            );
                            if (widget.addCardForSignUpProcess) {
                              context.read<SigninCubit>().addCard(newPinextCard);
                            } else {
                              context.read<CardsAndBalancesCubit>().addCard(newPinextCard);
                            }
                            Navigator.pop(context);
                            GetCustomSnackbar(
                              title: "Pinext Card added!!",
                              message: "A new card has been added to your card list.",
                              snackbarType: SnackbarType.success,
                              context: context,
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        final demoBlocState = context.watch<DemoBloc>().state;
                        return GetCustomButton(
                          title: widget.isEditCardScreen ? "Update Pinext Card" : "Add Pinext Card",
                          titleColor: whiteColor,
                          buttonColor: customBlueColor,
                          isLoading: state is AddCardDefaultState ? false : true,
                          callBackFunction: () {
                            if (demoBlocState is DemoDisabledState) {
                              if (_formKey.currentState!.validate()) {
                                if (widget.isEditCardScreen) {
                                  context.read<AddCardCubit>().updateCardDetails(
                                        titleController.text,
                                        descriptionController.text,
                                        balanceController.text,
                                        isEditCardColor!,
                                      );
                                } else {
                                  context.read<AddCardCubit>().addCard(
                                        titleController.text,
                                        descriptionController.text,
                                        balanceController.text,
                                        state.color,
                                      );
                                }
                              }
                            }
                          },
                        );
                      },
                    ),
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
