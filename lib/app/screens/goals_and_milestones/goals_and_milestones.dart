import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/bloc/signup_cubit/signin_cubit_cubit.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:uuid/uuid.dart';

import '../../app_data/app_constants/fonts.dart';
import '../../app_data/theme_data/colors.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';

class GoalsAndMilestoneScreen extends StatelessWidget {
  const GoalsAndMilestoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoalsAndMilestoneView();
  }
}

class GoalsAndMilestoneView extends StatefulWidget {
  const GoalsAndMilestoneView({super.key});

  @override
  State<GoalsAndMilestoneView> createState() => _GoalsAndMilestoneScreenState();
}

class _GoalsAndMilestoneScreenState extends State<GoalsAndMilestoneView> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                "Pinext",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
              Text(
                "Goals and Milestones",
                style: boldTextStyle.copyWith(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "What are your saving up for?",
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomTextFormField(
                controller: titleController,
                hintTitle: "Ex:  a new bike....",
                textInputType: TextInputType.number,
                onChanged: (String value) {},
                validator: (value) {
                  if (value.toString().isNotEmpty) {
                    return null;
                  } else {
                    return "Title can't be empty!";
                  }
                },
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "*This will be the title of you goal or milestone.",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Amount",
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomTextFormField(
                controller: amountController,
                hintTitle: "Ex: 400,000Tk",
                textInputType: TextInputType.number,
                onChanged: (String value) {},
                validator: (value) {
                  return InputValidation(value).isCorrectNumber();
                },
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "*This will be the title of you goal or milestone.",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Detailed Description",
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomTextFormField(
                controller: descriptionController,
                numberOfLines: 5,
                hintTitle: "Ex: 400,000Tk",
                textInputType: TextInputType.number,
                onChanged: (String value) {},
                validator: (value) {
                  // return InputValidation(value).isCorrectNumber();
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              GetCustomButton(
                title: "Add",
                titleColor: whiteColor,
                buttonColor: customBlueColor,
                isLoading: false,
                callBackFunction: () {
                  if (_formKey.currentState!.validate()) {
                    PinextGoalModel pinextGoalModel = PinextGoalModel(
                      title: titleController.text,
                      amount: amountController.text,
                      description: descriptionController.text,
                      id: const Uuid().v4().toString(),
                    );
                    context.read<SigninCubit>().addGoal(pinextGoalModel);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
