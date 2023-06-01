import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/cards_and_balances_cubit/cards_and_balances_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/add_and_edit_pinext_card/add_and_edit_pinext_card.dart';
import 'package:pinext/app/screens/home/widgets/get_card_list.dart';
import 'package:pinext/app/screens/home/widgets/homepage_get_balance_widget.dart';
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
            Animate(
              effects: const [
                SlideEffect(),
                FadeEffect(),
              ],
              child: Text(
                'Cards & Balances',
                style: cursiveTextStyle.copyWith(
                  fontSize: 30,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            HomepageGetBalanceWidget(),
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
                  context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
                }
                if (state is CardsAndBalancesSuccessfullyRemovedCardState) {
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
