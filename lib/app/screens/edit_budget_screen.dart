import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/bloc/edit_budget_cubit/edit_budget_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/shared/widgets/custom_button.dart';

import '../app_data/app_constants/fonts.dart';
import '../app_data/theme_data/colors.dart';
import '../shared/widgets/custom_snackbar.dart';
import '../shared/widgets/custom_text_field.dart';

class EditbudgetScreen extends StatelessWidget {
  EditbudgetScreen({
    super.key,
    required this.monthlyBudget,
    required this.amountSpentSoFar,
  });

  String monthlyBudget;
  String amountSpentSoFar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditBudgetCubit(),
      child: Editbudgetview(
        monthlyBudget: monthlyBudget,
        amountSpentSoFar: amountSpentSoFar,
      ),
    );
  }
}

class Editbudgetview extends StatelessWidget {
  Editbudgetview({
    super.key,
    required this.monthlyBudget,
    required this.amountSpentSoFar,
  });

  String monthlyBudget;
  String amountSpentSoFar;

  TextEditingController monthlyBudgetController = TextEditingController();
  TextEditingController amountSpentSoFarController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    monthlyBudgetController.text = monthlyBudget;
    amountSpentSoFarController.text = amountSpentSoFar;
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
          "Budget",
          style: regularTextStyle,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Monthly Budget",
                    style: boldTextStyle,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomTextFormField(
                    controller: monthlyBudgetController,
                    hintTitle: "Enter your monthly budget",
                    textInputType: TextInputType.number,
                    onChanged: (String value) {},
                    validator: (String value) {
                      return InputValidation(value).isCorrectNumber();
                    },
                    suffixButtonAction: () {},
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "*This is the maximum amount of CASH you'll be spending in one month!",
                    style: regularTextStyle.copyWith(
                      color: customBlackColor.withOpacity(.4),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "And how much of that have you spent so far?",
                    style: boldTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFormField(
                    controller: amountSpentSoFarController,
                    hintTitle: "Budget spent so far...",
                    textInputType: TextInputType.number,
                    onChanged: (String value) {},
                    validator: (String value) {
                      return InputValidation(value).isCorrectNumber();
                    },
                    suffixButtonAction: () {},
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocConsumer<EditBudgetCubit, EditBudgetState>(
                    listener: ((cubitContext, state) {
                      if (state is EditBudgetSuccessState) {
                        context.read<UserBloc>().add(RefreshUserStateEvent());
                        Navigator.pop(context);
                        context.read<EditBudgetCubit>().resetState();
                      } else if (state is EditBudgetErrorState) {
                        GetCustomSnackbar(
                          title: "Snap",
                          message: state.errorMessage,
                          snackbarType: SnackbarType.error,
                          context: context,
                        );
                        context.read<EditBudgetCubit>().resetState();
                      }
                    }),
                    builder: (context, state) {
                      return GetCustomButton(
                        title: "Update",
                        isLoading: state is EditBudgetLoadingState,
                        titleColor: Colors.white,
                        buttonColor: customBlueColor,
                        callBackFunction: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<EditBudgetCubit>().updateBudgetAndMonthlyExpenses(
                                  monthlyBudget: monthlyBudgetController.text,
                                  amountSpentSoFar: amountSpentSoFarController.text,
                                );
                          }
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
