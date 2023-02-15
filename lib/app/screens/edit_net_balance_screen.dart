import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/bloc/edit_net_balance_cubit/edit_net_balance_cubit.dart';

import '../app_data/app_constants/domentions.dart';
import '../app_data/app_constants/fonts.dart';
import '../app_data/theme_data/colors.dart';
import '../bloc/demoBloc/demo_bloc.dart';
import '../bloc/userBloc/user_bloc.dart';
import '../shared/widgets/custom_button.dart';
import '../shared/widgets/custom_snackbar.dart';
import '../shared/widgets/custom_text_field.dart';
import '../shared/widgets/info_widget.dart';

class EditNetBalanceScreen extends StatelessWidget {
  EditNetBalanceScreen({
    super.key,
    required this.netBalance,
  });

  String netBalance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditNetBalanceCubit(),
      child: EditNetBalanceView(
        netBalance: netBalance,
      ),
    );
  }
}

class EditNetBalanceView extends StatelessWidget {
  EditNetBalanceView({
    super.key,
    required this.netBalance,
  });

  String netBalance;

  TextEditingController netBalanceController = TextEditingController();

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
          "Edit net balance",
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
                  Container(
                    padding: const EdgeInsets.all(
                      defaultPadding,
                    ),
                    width: getWidth(context),
                    decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(
                        defaultBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Your current NET. balance is",
                          style: regularTextStyle,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Builder(
                          builder: (context) {
                            final demoBlocState = context.watch<DemoBloc>().state;
                            return Text(
                              demoBlocState is DemoEnabledState ? "750000 Tk" : "$netBalance Tk",
                              style: boldTextStyle.copyWith(
                                fontSize: 25,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Do you want to update it?",
                    style: boldTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFormField(
                    controller: netBalanceController,
                    hintTitle: "Enter updated NET. balance...",
                    textInputType: TextInputType.number,
                    onChanged: (String value) {},
                    validator: (String value) {
                      return InputValidation(value).isCorrectNumber();
                    },
                    suffixButtonAction: () {},
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InfoWidget(
                    infoText:
                        "Updating your NET balance will not affect any of your card balances, but will effect your total cumulative NET balance statistics!",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocConsumer<EditNetBalanceCubit, EditNetBalanceState>(
                    listener: ((cubitContext, state) {
                      if (state is EditNetBalanceSuccessState) {
                        context.read<UserBloc>().add(RefreshUserStateEvent());
                        Navigator.pop(context);
                        context.read<EditNetBalanceCubit>().resetState();
                      } else if (state is EditNetBalanceErrorState) {
                        GetCustomSnackbar(
                          title: "Snap",
                          message: state.errorMessage,
                          snackbarType: SnackbarType.error,
                          context: context,
                        );
                        context.read<EditNetBalanceCubit>().resetState();
                      }
                    }),
                    builder: (context, state) {
                      final demoBlocState = context.watch<DemoBloc>().state;
                      return GetCustomButton(
                        title: "Update",
                        isLoading: state is EditNetBalanceLoadingState,
                        titleColor: Colors.white,
                        buttonColor: customBlueColor,
                        callBackFunction: () {
                          if (demoBlocState is DemoDisabledState) {
                            if (netBalanceController.text == netBalance) {
                              GetCustomSnackbar(
                                title: "!!",
                                message: "Please update with a new amount and try again!",
                                snackbarType: SnackbarType.error,
                                context: context,
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              context.read<EditNetBalanceCubit>().updateNetBalance(
                                    newNetBalance: netBalanceController.text,
                                  );
                            }
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
