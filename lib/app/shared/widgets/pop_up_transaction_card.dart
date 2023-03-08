import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/shared/widgets/pinext_card.dart';
import 'package:pinext/app/shared/widgets/rotatable_card.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

void showPinextCardPopup(
  BuildContext context,
  // PinextTransactionModel pinextTransactionModel,
  PinextCardModel cardModel,
) {
  final dialog = Dialog(
    elevation: 0,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        16,
      ),
    ),

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
            balance: cardModel.balance,
            lastTransactionDate: cardModel.lastTransactionData,
            cardId: cardModel.cardId,
          ),
          back: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(
                  15,
                ),
                height: 180,
                width: getWidth(context) * .9,
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
              Container(
                padding: const EdgeInsets.all(
                  15,
                ),
                height: 180,
                width: getWidth(context) * .9,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  borderRadius: BorderRadius.circular(
                    defaultBorder,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: SfBarcodeGenerator(
                        value: 'Crafted by KYOTO',
                        barColor: whiteColor,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      cardModel.cardId.substring(0, 16),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: whiteColor.withOpacity(.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => dialog);
}
