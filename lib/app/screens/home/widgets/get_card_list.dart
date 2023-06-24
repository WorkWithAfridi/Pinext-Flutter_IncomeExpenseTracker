import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/cards_and_balances_cubit/cards_and_balances_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/screens/add_and_edit_pinext_card/add_and_edit_pinext_card.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/pinext_card_minimized.dart';

class GetCardList extends StatelessWidget {
  const GetCardList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CardsAndBalancesCubit, CardsAndBalancesState>(
      listener: (context, state) {
        if (state is CardsAndBalancesSuccessfullyRemovedCardState) {
          context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
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
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Text(
              'Please add a Pinext card to view your cards details here.',
              style: regularTextStyle.copyWith(
                color: customBlackColor.withOpacity(.4),
              ),
            );
          }
          context.read<UserBloc>().add(RefreshUserStateEvent(context: context));
          return MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            removeTop: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final pinextCardModel = PinextCardModel.fromMap(
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
                                      'Before proceeding with the removal of this card from your pinext account, kindly confirm your decision. Are you sure you want to delete this card? Thank you for your attention to this matter.',
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
                          },
                        );
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
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
