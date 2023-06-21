import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/screens/add_and_edit_pinext_card/add_and_edit_pinext_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class PinextCard extends StatelessWidget {
  PinextCard({
    required this.cardId,
    required this.cardDetails,
    required this.lastTransactionDate,
    super.key,
    this.isSelected = false,
    this.cardColor = 'Midnight Indigo',
    this.title = 'Test Title',
    this.balance = 0.00,
    this.cardModel,
  });

  bool isSelected;
  String cardColor;
  String cardId;
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
        final regionState = context.watch<RegionCubit>().state;
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(
                15,
              ),
              height: getCardHeight(context),
              width: getCardWidth(context),
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
            ),
            Container(
              padding: const EdgeInsets.all(
                15,
              ),
              height: getCardHeight(context),
              width: getCardWidth(context),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.10),
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
                              demoBlocState is DemoEnabledState ? 'Bank' : title,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
                                fontFamily: 'BakbakOne',
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
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                              ),
                            ),
                            if (cardId != '')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(defaultBorder),
                                      child: Image.asset(
                                        'assets/app_icon/aap_icon.png',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '•••• •••• •••• ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: whiteColor.withOpacity(.8),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        cardId.substring(cardId.length - 4, cardId.length),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: whiteColor.withOpacity(.8),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              const SizedBox.shrink(),
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
                              'Current balance',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: whiteColor.withOpacity(.6),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: 1,
                              color: whiteColor.withOpacity(.6),
                              width: getWidth(context),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    demoBlocState is DemoEnabledState ? '55000' : balance.toInt().toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: whiteColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  ' ${regionState.countryData.symbol}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: whiteColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
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
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: 1,
                              color: whiteColor.withOpacity(.6),
                              width: getWidth(context),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            FittedBox(
                              child: Text(
                                '${timeago.format(
                                      DateTime.parse(
                                        lastTransactionDate,
                                      ),
                                    ).capitalize()} ',
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
                  // if (cardModel != null)
                  //   Center(
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(
                  //           25,
                  //         ),
                  //         border: Border.all(
                  //           color: Colors.white.withOpacity(.1),
                  //         ),
                  //       ),
                  //       padding: const EdgeInsets.all(10),
                  //       child: Icon(
                  //         AntIcons.editOutlined_note_rounded,
                  //         color: Colors.white.withOpacity(.1),
                  //       ),
                  //     ),
                  //   )
                  // else
                  //   const SizedBox.shrink(),
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
            ),
          ],
        );
      },
    );
  }
}

double getCardHeight(BuildContext context) {
  return (getWidth(context) * .85) / 1.7;
}

double getCardWidth(BuildContext context) {
  return getWidth(context) * .85;
}
