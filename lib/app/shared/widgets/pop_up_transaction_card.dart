import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../app_data/app_constants/fonts.dart';

void showPinextCardPopup(
  BuildContext context,
  // PinextTransactionModel pinextTransactionModel,
  PinextCardModel cardModel,
) {
  var dialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    //this right here
    child: Builder(
      builder: (context) {
        final demoBlocState = context.watch<DemoBloc>().state;
        return Container(
          padding: const EdgeInsets.all(
            15,
          ),
          height: 180,
          width: getWidth(context) * .8,
          decoration: BoxDecoration(
            color: getColorFromString(cardModel.color),
            borderRadius: BorderRadius.circular(
              defaultBorder,
            ),
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          demoBlocState is DemoEnabledState ? "Bank" : cardModel.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: whiteColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Expanded(
                          child: Text(
                            demoBlocState is DemoEnabledState
                                ? "The purpose of lorem ipsum is to create a natural looking block of text (sentence, paragraph, page, etc.) that doesn't distract from the layout."
                                    .capitalize()
                                : cardModel.description.capitalize(),
                            style: regularTextStyle.copyWith(
                              color: whiteColor.withOpacity(.4),
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 4,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current balance",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                color: whiteColor.withOpacity(.6),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  demoBlocState is DemoEnabledState ? "55000 Tk" : cardModel.balance.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: whiteColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  "/",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: whiteColor.withOpacity(.4),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  "Tk",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: whiteColor.withOpacity(.4),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last transaction",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: whiteColor.withOpacity(.6),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            "${timeago.format(
                              DateTime.parse(cardModel.lastTransactionData),
                            )} ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => dialog);
}
