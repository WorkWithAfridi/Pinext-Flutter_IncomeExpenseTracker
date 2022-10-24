import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';

import '../../app_data/app_constants/domentions.dart';
import '../../app_data/app_constants/fonts.dart';
import '../../app_data/custom_transition_page_route/custom_transition_page_route.dart';
import '../../app_data/theme_data/colors.dart';
import '../../models/pinext_goal_model.dart';
import '../../services/firebase_services.dart';
import '../../shared/widgets/pinext_goal_minimized.dart';
import 'add_and_edit_goal_and_milestone_screen.dart';

class ViewGoalsAndMilestoneScreen extends StatelessWidget {
  const ViewGoalsAndMilestoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ViewGoalsAndMilestoneView();
  }
}

class ViewGoalsAndMilestoneView extends StatelessWidget {
  const ViewGoalsAndMilestoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: customBlackColor,
          ),
        ),
      ),
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pinext",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.6),
                ),
              ),
              Text(
                "Goals & Milestones",
                style: boldTextStyle.copyWith(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Your current goals are",
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              StreamBuilder(
                stream: FirebaseServices()
                    .firebaseFirestore
                    .collection('pinext_users')
                    .doc(FirebaseServices().getUserId())
                    .collection('pinext_goals')
                    .snapshots(),
                builder: ((context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox.shrink(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Text(
                      "404 - No record found!",
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
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length > 10 ? 10 : snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            if (snapshot.data!.docs.isEmpty) {
                              return const Text("No data found! :(");
                            }
                            if (snapshot.data!.docs.isEmpty) {
                              return Text(
                                "No data found! :(",
                                style: regularTextStyle.copyWith(
                                  color: customBlackColor.withOpacity(.4),
                                ),
                              );
                            }

                            PinextGoalModel pinextGoalModel = PinextGoalModel.fromMap(
                              snapshot.data!.docs[index].data(),
                            );
                            return PinextGoalCardMinimized(
                              pinextGoalModel: pinextGoalModel,
                              index: index,
                              showCompletePercentage: true,
                            );
                          }),
                        ),
                      )
                    ],
                  );
                }),
              ),
              Text(
                "*Please delete your milestones, once you've achieved them! Or else they will again pop up once your balance goes below the completed milestones amount!",
                style: regularTextStyle.copyWith(
                  color: customBlackColor.withOpacity(.4),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "New goal?",
                style: boldTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CustomTransitionPageRoute(
                      childWidget: AddAndEditGoalsAndMilestoneScreen(
                        addingNewGoal: true,
                        addingNewGoalDuringSignupProcess: false,
                        editingGoal: false,
                        pinextGoalModel: null,
                      ),
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
                        "Add a goal/ milestone",
                        style: boldTextStyle.copyWith(
                          color: customBlackColor.withOpacity(.4),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
