import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/shared/widgets/animated_counter_text_widget.dart';
import 'package:pinext/app/shared/widgets/pop_up_transaction_card.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../app_data/app_constants/constants.dart';
import '../../app_data/app_constants/domentions.dart';
import '../../app_data/theme_data/colors.dart';
import '../../bloc/demoBloc/demo_bloc.dart';
import '../../models/pinext_card_model.dart';

class PinextCardMinimized extends StatelessWidget {
  PinextCardMinimized({
    Key? key,
    required this.pinextCardModel,
    required this.onDeleteButtonClick,
    required this.onEditButtonClick,
  }) : super(key: key);

  final PinextCardModel pinextCardModel;

  Function onDeleteButtonClick;
  Function onEditButtonClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPinextCardPopup(
          context,
          pinextCardModel,
        );
      },
      child: Card(
        elevation: 0,
        shadowColor: greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            defaultBorder,
          ),
        ),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.circular(
              defaultBorder,
            ),
          ),
          width: getWidth(context),
          child: Builder(
            builder: (context) {
              final demoBlocState = context.watch<DemoBloc>().state;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            demoBlocState is DemoEnabledState ? "Bank" : pinextCardModel.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: customBlackColor,
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: .5,
                            color: customBlackColor.withOpacity(.2),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current balance",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                  color: customBlackColor.withOpacity(.4),
                                ),
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AnimatedCounterTextWidget(
                                    begin: 0,
                                    end: demoBlocState is DemoEnabledState
                                        ? 55000.0
                                        : double.parse(pinextCardModel.balance.toString()),
                                    maxLines: 1,
                                    precision: 2,
                                    style: boldTextStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: customBlackColor,
                                    ),
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                  const Text('/Tk'),
                                ],
                              ),
                              // Text(
                              //   pinextCardModel.balance.toString(),
                              //   style: const TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 20,
                              //     color: customBlackColor,
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: .5,
                        height: getHeight(context),
                        color: customBlackColor.withOpacity(.2),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Last transaction",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: customBlackColor.withOpacity(.4),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                "  ${timeago.format(
                                  DateTime.parse(
                                    pinextCardModel.lastTransactionData,
                                  ),
                                )}  ",
                                style: regularTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Row(
                        children: [
                          Container(
                            width: .5,
                            height: getHeight(context),
                            color: customBlackColor.withOpacity(.2),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  onEditButtonClick();
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: customBlackColor,
                                ),
                              ),
                              Container(
                                width: 55,
                                height: .5,
                                color: customBlackColor.withOpacity(.2),
                              ),
                              IconButton(
                                onPressed: () {
                                  demoBlocState is DemoEnabledState ? () {} : onDeleteButtonClick();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: customBlackColor,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
