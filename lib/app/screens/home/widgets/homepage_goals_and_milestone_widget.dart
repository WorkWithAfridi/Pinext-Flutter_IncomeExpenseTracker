import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/custom_transition_page_route/custom_transition_page_route.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_goal_model.dart';
import 'package:pinext/app/screens/goals_and_milestones/view_goals_and_milestones_screen.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/pinext_goal_minimized.dart';

class HomepageGetGoalsAndMilestonesWidget extends StatelessWidget {
  const HomepageGetGoalsAndMilestonesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Goals & milestones',
              style: boldTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CustomTransitionPageRoute(
                    childWidget: const ViewGoalsAndMilestoneScreen(),
                  ),
                );
              },
              child: Text(
                'View all',
                style: regularTextStyle.copyWith(
                  fontSize: 14,
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        StreamBuilder(
          stream: FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).collection('pinext_goals').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox.shrink(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Text(
                '404 - No record found!',
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length > 5 ? 5 : snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (snapshot.data!.docs.isEmpty) {
                        return const Text('No data found! :(');
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Text(
                          'No data found! :(',
                          style: regularTextStyle.copyWith(
                            color: customBlackColor.withOpacity(.4),
                          ),
                        );
                      }

                      final pinextGoalModel = PinextGoalModel.fromMap(
                        snapshot.data!.docs[index].data(),
                      );
                      return BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          var completionAmount = 0;
                          if (state is AuthenticatedUserState) {
                            completionAmount = ((double.parse(state.netBalance) / double.parse(pinextGoalModel.amount)) * 100).toInt();
                          }
                          return PinextGoalCardMinimized(
                            pinextGoalModel: pinextGoalModel,
                            index: index,
                            showCompletePercentage: true,
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
