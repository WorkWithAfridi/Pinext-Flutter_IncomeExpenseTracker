import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/cards_and_balances_cubit/cards_and_balances_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/add_and_edit_pinext_card/add_and_edit_pinext_card.dart';
import 'package:pinext/app/screens/edit_net_balance_screen.dart';
import 'package:pinext/app/screens/home/widgets/get_card_list.dart';
import 'package:pinext/app/shared/widgets/animated_counter_text_widget.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';

class CardsAndBalancePage extends StatelessWidget {
  const CardsAndBalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardsAndBalancesCubit(),
      child: const CardsAndBalanceView(),
    );
  }
}

class CardsAndBalanceView extends StatelessWidget {
  const CardsAndBalanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cards & Balances',
              style: cursiveTextStyle.copyWith(
                fontSize: 30,
                color: primaryColor,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(
                35,
              ),
              height: 180,
              width: getWidth(context),
              decoration: BoxDecoration(
                color: customBlackColor,
                borderRadius: BorderRadius.circular(
                  defaultBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your NET. Balance is',
                    style: boldTextStyle.copyWith(
                      color: whiteColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final state = context.watch<UserBloc>().state;
                      final demoBlocState = context.watch<DemoBloc>().state;
                      if (state is AuthenticatedUserState) {
                        return SizedBox(
                          height: 70,
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.edit,
                                size: 20,
                                color: customBlackColor,
                              ),
                              Expanded(
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      AnimatedCounterTextWidget(
                                        begin: 0,
                                        end: demoBlocState is DemoEnabledState ? 750000.0 : double.parse(state.netBalance),
                                        maxLines: 1,
                                        precision: 2,
                                        style: boldTextStyle.copyWith(
                                          color: whiteColor,
                                          fontSize: 50,
                                        ),
                                        curve: Curves.fastOutSlowIn,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    CustomTransitionPageRoute(
                                      childWidget: EditNetBalanceScreen(
                                        netBalance: state.netBalance,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: whiteColor,
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  Text(
                    'Taka',
                    style: boldTextStyle.copyWith(
                      color: whiteColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Manage Cards',
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            const GetCardList(),
            const SizedBox(
              height: 12,
            ),
            Text(
              'New Card??',
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            BlocListener<CardsAndBalancesCubit, CardsAndBalancesState>(
              listener: (context, state) {
                if (state is CardsAndBalancesSuccessfullyAddedCardState) {
                  log('Card added');
                  context.read<UserBloc>().add(RefreshUserStateEvent());
                }
                if (state is CardsAndBalancesSuccessfullyRemovedCardState) {
                  log('removed');
                  GetCustomSnackbar(
                    title: 'Success',
                    message: 'Card has been removed from your card list.',
                    snackbarType: SnackbarType.success,
                    context: context,
                  );
                }
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CustomTransitionPageRoute(
                      childWidget: AddAndEditPinextCardScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(
                      defaultBorder,
                    ),
                  ),
                  alignment: Alignment.center,
                  width: getWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25,
                          ),
                          border: Border.all(
                            color: customBlackColor.withOpacity(.4),
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: customBlackColor.withOpacity(.4),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Add a new card',
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
