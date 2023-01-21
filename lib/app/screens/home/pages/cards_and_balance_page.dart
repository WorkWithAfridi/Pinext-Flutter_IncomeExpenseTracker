import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mccounting_text/mccounting_text.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/bloc/cards_and_balances_cubit/cards_and_balances_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/screens/edit_net_balance_screen.dart';

import '../../../app_data/app_constants/constants.dart';
import '../../../app_data/app_constants/domentions.dart';
import '../../../app_data/app_constants/fonts.dart';
import '../../../app_data/theme_data/colors.dart';
import '../../../bloc/demoBloc/demo_bloc.dart';
import '../../../models/pinext_card_model.dart';
import '../../../services/firebase_services.dart';
import '../../../shared/widgets/pinext_card_minimized.dart';
import '../../add_and_edit_pinext_card/add_and_edit_pinext_card.dart';

class CardsAndBalancePage extends StatelessWidget {
  const CardsAndBalancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardsAndBalancesCubit(),
      child: const CardsAndBalanceView(),
    );
  }
}

class CardsAndBalanceView extends StatelessWidget {
  const CardsAndBalanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cards and Balances",
              style: boldTextStyle.copyWith(
                fontSize: 25,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Your NET. Balance is",
                    style: boldTextStyle.copyWith(
                      color: whiteColor.withOpacity(.6),
                      fontSize: 16,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final state = context.read<UserBloc>().state;
                      final demoBlocState = context.watch<DemoBloc>().state;
                      if (state is AuthenticatedUserState) {
                        return SizedBox(
                          height: 70,
                          width: double.maxFinite,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                      McCountingText(
                                        begin: 0,
                                        end: demoBlocState is DemoEnabledState
                                            ? 750000.0
                                            : double.parse(state.netBalance),
                                        maxLines: 1,
                                        precision: 2,
                                        style: boldTextStyle.copyWith(
                                          color: whiteColor,
                                          fontSize: 50,
                                        ),
                                        duration: const Duration(seconds: 3),
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
                    "Taka",
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
              "Manage Cards",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            BlocListener<CardsAndBalancesCubit, CardsAndBalancesState>(
              listener: (context, state) {
                if (state is CardsAndBalancesSuccessfullyRemovedCardState) {
                  context.read<UserBloc>().add(RefreshUserStateEvent());
                  context.read<CardsAndBalancesCubit>().resetState();
                }
              },
              child: StreamBuilder(
                stream: FirebaseServices()
                    .firebaseFirestore
                    .collection(USERS_DIRECTORY)
                    .doc(FirebaseServices().getUserId())
                    .collection(CARDS_DIRECTORY)
                    .orderBy(
                      'lastTransactionData',
                      descending: true,
                    )
                    .snapshots(),
                builder: ((context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Text(
                      "Please add a Pinext card to view your cards details here.",
                      style: regularTextStyle.copyWith(
                        color: customBlackColor.withOpacity(.4),
                      ),
                    );
                  }
                  context.read<UserBloc>().add(RefreshUserStateEvent());
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      PinextCardModel pinextCardModel = PinextCardModel.fromMap(
                        snapshot.data!.docs[index].data(),
                      );
                      return Builder(
                        builder: (context) {
                          final demoBlocState = context.watch<DemoBloc>().state;
                          return PinextCardMinimized(
                            pinextCardModel: pinextCardModel,
                            onDeleteButtonClick: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Delete card?',
                                        style: boldTextStyle.copyWith(
                                          fontSize: 20,
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                              "You're about to delete this card from your pinext account! Are you sure you want to do that??",
                                              style: regularTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(defaultBorder),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            'Cancel',
                                            style: boldTextStyle.copyWith(
                                              color: customBlackColor.withOpacity(
                                                .8,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Approve'),
                                          onPressed: () {
                                            context.read<CardsAndBalancesCubit>().removeCard(pinextCardModel);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                      actionsPadding: dialogButtonPadding,
                                    );
                                  });
                            },
                            onEditButtonClick: () {
                              Navigator.push(
                                  context,
                                  CustomTransitionPageRoute(
                                    childWidget: AddAndEditPinextCardScreen(
                                      isEditCardScreen: true,
                                      pinextCardModel: pinextCardModel,
                                      isDemoMode: demoBlocState is DemoEnabledState,
                                    ),
                                  ));
                            },
                          );
                        },
                      );
                    }),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "New Card??",
              style: boldTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            BlocListener<CardsAndBalancesCubit, CardsAndBalancesState>(
              listener: (context, state) {
                if (state is CardsAndBalancesSuccessfullyAddedCardState) {
                  log("Card added");
                  context.read<UserBloc>().add(RefreshUserStateEvent());
                }
                if (state is CardsAndBalancesSuccessfullyRemovedCardState) {
                  log("Card removed");
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
                        "Add a new card",
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
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
