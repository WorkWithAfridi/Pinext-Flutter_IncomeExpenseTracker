import 'dart:developer';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/add_goal_cubit/add_goal_cubit.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/signup_cubit/signin_cubit_cubit.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';
import 'package:uuid/uuid.dart';

class AddAndEditGoalsAndMilestoneScreen extends StatelessWidget {
  AddAndEditGoalsAndMilestoneScreen({
    super.key,
    required this.addingNewGoalDuringSignupProcess,
    required this.addingNewGoal,
    required this.editingGoal,
    required this.pinextGoalModel,
  });

  bool addingNewGoalDuringSignupProcess;
  bool addingNewGoal;
  bool editingGoal;
  PinextGoalModel? pinextGoalModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddGoalCubit(),
      child: AddAndEditGoalsAndMilestoneView(
        addingNewGoal: addingNewGoal,
        addingNewGoalDuringSignupProcess: addingNewGoalDuringSignupProcess,
        editingGoal: editingGoal,
        pinextGoalModel: pinextGoalModel,
      ),
    );
  }
}

class AddAndEditGoalsAndMilestoneView extends StatefulWidget {
  AddAndEditGoalsAndMilestoneView({
    super.key,
    required this.addingNewGoalDuringSignupProcess,
    required this.addingNewGoal,
    required this.editingGoal,
    required this.pinextGoalModel,
  });

  bool addingNewGoalDuringSignupProcess;
  bool addingNewGoal;
  bool editingGoal;
  PinextGoalModel? pinextGoalModel;

  @override
  State<AddAndEditGoalsAndMilestoneView> createState() => _AddAndEditGoalsAndMilestoneState();
}

class _AddAndEditGoalsAndMilestoneState extends State<AddAndEditGoalsAndMilestoneView> {
  late TextEditingController titleController;

  late TextEditingController amountController;

  late TextEditingController descriptionController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    amountController = TextEditingController();
    descriptionController = TextEditingController();
    if (widget.editingGoal) {
      titleController.text = widget.pinextGoalModel!.title;
      amountController.text = widget.pinextGoalModel!.amount;
      descriptionController.text = widget.pinextGoalModel!.description;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
          widget.editingGoal ? 'Editing goal' : 'Adding a new goal',
          style: regularTextStyle,
        ),
        centerTitle: true,
        actions: [
          if (widget.editingGoal)
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: Text(
                            'Delete milestone?',
                            style: boldTextStyle.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text(
                                  "You're about to delete this milestone from your pinext account! Are you sure you want to do that??",
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
                                context.read<AddGoalCubit>().deleteGoal(widget.pinextGoalModel!);
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
                )
              ],
            )
          else
            const SizedBox.shrink()
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pinext',
                  style: regularTextStyle.copyWith(
                    color: customBlackColor.withOpacity(.6),
                  ),
                ),
                Text(
                  'Goals & Milestones',
                  style: boldTextStyle.copyWith(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'What are your saving up for?',
                      style: boldTextStyle,
                    ),
                    InfoWidget(
                      infoText: 'This will be the title of you goal or milestone.',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFormField(
                  controller: titleController,
                  hintTitle: 'Ex:  a new bike....',
                  onChanged: (String value) {},
                  validator: (value) {
                    if (value.toString().isNotEmpty) {
                      return null;
                    } else {
                      return "Title can't be empty!";
                    }
                  },
                  suffixButtonAction: () {},
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: boldTextStyle,
                    ),
                    InfoWidget(
                      infoText: 'This is the amount you need to save to achieve/ complete your goal/ milestone.',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<RegionCubit, RegionState>(
                  builder: (context, state) {
                    return CustomTextFormField(
                      controller: amountController,
                      hintTitle: 'Ex: 400,000${state.countryData.symbol}',
                      textInputType: TextInputType.number,
                      onChanged: (String value) {},
                      validator: (String value) {
                        return InputValidation(value).isCorrectNumber();
                      },
                      suffixButtonAction: () {},
                    );
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Detailed Description',
                  style: boldTextStyle,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFormField(
                  controller: descriptionController,
                  numberOfLines: 5,
                  hintTitle: 'Ex: Buying a new bike',
                  onChanged: (String value) {},
                  validator: (value) {
                    // return InputValidation(value).isCorrectNumber();
                    return null;
                  },
                  suffixButtonAction: () {},
                ),
                const SizedBox(
                  height: 12,
                ),
                BlocConsumer<AddGoalCubit, AddGoalState>(
                  listener: (addGoalContext, state) {
                    if (state is AddGoalSuccessState) {
                      Navigator.pop(context);
                      showToast(
                        title: 'Pinext Goal added!!',
                        message: 'A new goal has been added.',
                        snackbarType: SnackbarType.success,
                        context: context,
                      );
                    } else if (state is AddGoalErrorState) {
                      log('An error occurred while trying to add a new goal!');
                    } else if (state is UpdateGoalSuccessState) {
                      Navigator.pop(context);
                      showToast(
                        title: 'Pinext Goal updated!!',
                        message: 'Your goal has been updated',
                        snackbarType: SnackbarType.success,
                        context: context,
                      );
                    } else if (state is DeleteGoalSuccessState) {
                      Navigator.pop(context);
                      showToast(
                        title: 'Pinext Goal Deleted',
                        message: 'Your goal has been achieved!',
                        snackbarType: SnackbarType.success,
                        context: context,
                      );
                    }
                  },
                  builder: (addGoalContext, state) {
                    return GetCustomButton(
                      title: widget.editingGoal ? 'Update' : 'Add',
                      titleColor: whiteColor,
                      buttonColor: primaryColor,
                      isLoading: state is AddGoalLoadingState,
                      callBackFunction: () async {
                        // final demoState = context.watch<DemoBloc>().state;
                        // if (demoState is DemoDisabledState) {

                        // }
                        if (_formKey.currentState!.validate()) {
                          if (widget.addingNewGoalDuringSignupProcess) {
                            final pinextGoalModel = PinextGoalModel(
                              title: titleController.text,
                              amount: amountController.text,
                              description: descriptionController.text,
                              id: const Uuid().v4().toString(),
                            );
                            context.read<SigninCubit>().addGoal(pinextGoalModel);
                            Navigator.pop(context);
                          } else if (widget.addingNewGoal) {
                            final pinextGoalModel = PinextGoalModel(
                              title: titleController.text,
                              amount: amountController.text,
                              description: descriptionController.text,
                              id: const Uuid().v4().toString(),
                            );
                            await addGoalContext.read<AddGoalCubit>().addGoal(pinextGoalModel);
                          } else if (widget.editingGoal) {
                            final pinextGoalModel = PinextGoalModel(
                              title: titleController.text,
                              amount: amountController.text,
                              description: descriptionController.text,
                              id: widget.pinextGoalModel!.id,
                            );
                            await addGoalContext.read<AddGoalCubit>().updateGoal(pinextGoalModel);
                          }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
