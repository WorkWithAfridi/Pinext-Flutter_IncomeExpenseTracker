import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';
import 'package:pinext/app/shared/widgets/rotatable_card.dart';

void showPinextCardPopup(
  BuildContext context,
  // PinextTransactionModel pinextTransactionModel,
  PinextCardModel cardModel,
) {
  final dialog = Dialog(
    elevation: 0,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //this right here
    child: Builder(
      builder: (context) {
        final demoBlocState = context.watch<DemoBloc>().state;
        return RotatableCard(
          front: PinextCard(
            cardDetails: cardModel.description,
            cardColor: cardModel.color,
            cardModel: cardModel,
            title: cardModel.title,
            lastTransactionDate: cardModel.lastTransactionData,
          ),
          back: Container(
            padding: const EdgeInsets.all(
              15,
            ),
            height: 180,
            width: getWidth(context) * .8,
            decoration: BoxDecoration(
              // color: cardColor,
              borderRadius: BorderRadius.circular(
                defaultBorder,
              ),
              gradient: LinearGradient(
                colors: GetGradientFromString(
                  cardModel.color,
                ).reversed.toList(),
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
        );
      },
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => dialog);
}
