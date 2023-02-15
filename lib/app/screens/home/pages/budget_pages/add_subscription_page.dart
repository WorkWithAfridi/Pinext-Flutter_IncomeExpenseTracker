import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/info_widget.dart';

class AddSubscriptionPage extends StatelessWidget {
  AddSubscriptionPage({
    super.key,
  });

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
          "Add subscription",
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
                        "Subscription title",
                        style: boldTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: TextEditingController(),
                        hintTitle: "Netflix subscription",
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
                        "Subscription description",
                        style: boldTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        numberOfLines: 4,
                        controller: TextEditingController(),
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
                        "Subscription amount",
                        style: boldTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        numberOfLines: 1,
                        controller: TextEditingController(),
                        hintTitle: "",
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
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                    left: defaultPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Automatically pay",
                        style: boldTextStyle,
                      ),
                      Switch(
                        value: true,
                        activeColor: customBlueColor,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InfoWidget(
                        infoText:
                            "Enabling this option will automatically deduct the subscription amount at the start of everymonth, from the selected card!",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
