import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/screens/add_and_edit_pinext_card/add_and_edit_pinext_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class PinextCard extends StatelessWidget {
  PinextCard({
    super.key,
    this.isSelected = false,
    this.cardColor = 'Midnight Indigo',
    this.title = 'Test Title',
    this.balance = 0.00,
    this.cardModel,
    required this.cardDetails,
    required this.lastTransactionDate,
  });

  bool isSelected;
  String cardColor;
  double balance;
  String title;
  String cardDetails;
  String lastTransactionDate;
  PinextCardModel? cardModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: cardModel == null
          ? _getCard(context)
          : GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CustomTransitionPageRoute(
                    childWidget: AddAndEditPinextCardScreen(
                      isEditCardScreen: true,
                      pinextCardModel: cardModel,
                    ),
                  ),
                );
              },
              child: _getCard(context),
            ),
    );
  }

  Widget _getCard(BuildContext context) {
    return Builder(
      builder: (context) {
        final demoBlocState = context.watch<DemoBloc>().state;
        return Container(
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
                cardColor,
              ),
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
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
                          demoBlocState is DemoEnabledState ? 'Bank' : title,
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
                                : cardDetails.capitalize(),
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
                              'Current balance',
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
                                  demoBlocState is DemoEnabledState ? '55000 Tk' : balance.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: whiteColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  '/',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: whiteColor.withOpacity(.4),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  'Tk',
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
                          'Last transaction',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: whiteColor.withOpacity(.6),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            '${timeago.format(
                              DateTime.parse(
                                lastTransactionDate,
                              ),
                            )} ',
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
              if (cardModel != null)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(.1),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.edit_note_rounded,
                      color: Colors.white.withOpacity(.1),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              if (isSelected)
                const Center(
                  child: Icon(
                    Icons.done,
                    color: whiteColor,
                    size: 50,
                  ),
                )
              else
                const SizedBox.shrink()
            ],
          ),
        );
      },
    );
  }
}
