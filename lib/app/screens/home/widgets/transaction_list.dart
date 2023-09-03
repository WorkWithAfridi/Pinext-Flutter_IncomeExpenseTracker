import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/bloc/archive_cubit/search_cubit/search_cubit.dart';
import 'package:pinext/app/bloc/archive_cubit/user_statistics_cubit/user_statistics_cubit.dart';
import 'package:pinext/app/bloc/demoBloc/demo_bloc.dart';
import 'package:pinext/app/bloc/region_cubit/region_cubit.dart';
import 'package:pinext/app/bloc/userBloc/user_bloc.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/shared/widgets/custom_text_field.dart';
import 'package:pinext/app/shared/widgets/horizontal_bar.dart';
import 'package:pinext/app/shared/widgets/transaction_details_card.dart';

class TransactionsList extends StatelessWidget {
  TransactionsList({
    super.key,
  });

  List<String> filters = [
    'All transactions',
    'Income',
    'Expenses',
  ];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ArchiveCubit, ArchiveState>(
                  builder: (context, state) {
                    final selectedMonth = '0${int.parse(state.selectedMonth) + 1}'.length > 2
                        ? '0${int.parse(state.selectedMonth) + 1}'.substring(1, 3)
                        : '0${int.parse(state.selectedMonth) + 1}';
                    return StreamBuilder(
                      stream: FirebaseServices()
                          .firebaseFirestore
                          .collection('pinext_users')
                          .doc(FirebaseServices().getUserId())
                          .collection('pinext_transactions')
                          .doc(state.selectedYear)
                          .collection(selectedMonth)
                          .orderBy(
                            'transactionDate',
                            descending: true,
                          )
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: SizedBox.shrink(),
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          context.read<UserStatisticsCubit>().noDataFound(true);
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: Container(
                              // height: double.maxFinite,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: getHeight(context) / 2,
                                    width: getWidth(context) / 1.5,
                                    child: LottieBuilder.asset(
                                      'assets/animations/404.json',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        context.read<UserStatisticsCubit>().noDataFound(false);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Transactions',
                                  style: boldTextStyle.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const GetHorizontalBar(),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Wrap(
                                    spacing: 5,
                                    runSpacing: -8,
                                    children: [
                                      ...List.generate(
                                        filters.length,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              final selectedFilter = filters[index];
                                              if (state.selectedFilter == selectedFilter && selectedFilter == 'All transactions') {
                                                return;
                                              }
                                              if (state.selectedFilter != selectedFilter) {
                                                context.read<ArchiveCubit>().changeFilter(selectedFilter);
                                              } else {
                                                context.read<ArchiveCubit>().changeFilter(
                                                      'All transactions',
                                                    );
                                              }
                                              context.read<UserStatisticsCubit>().resetState();
                                            },
                                            child: Chip(
                                              elevation: 0,
                                              label: Text(
                                                filters[index],
                                                style: regularTextStyle.copyWith(
                                                  color: filters[index] == state.selectedFilter ? whiteColor : customBlackColor.withOpacity(.6),
                                                  fontWeight: filters[index] == state.selectedFilter ? FontWeight.w600 : FontWeight.normal,
                                                ),
                                              ),
                                              backgroundColor: filters[index] == state.selectedFilter ? primaryColor : greyColor,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.read<ArchiveSearchCubit>().toogleSearch();
                                    context.read<UserStatisticsCubit>().resetState();
                                  },
                                  child: BlocBuilder<ArchiveSearchCubit, ArchiveSearchState>(
                                    builder: (context, state) {
                                      return Icon(
                                        state.isSearchActive ? Icons.search_off_rounded : Icons.search_rounded,
                                        color: primaryColor,
                                        size: 25,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            BlocBuilder<ArchiveSearchCubit, ArchiveSearchState>(
                              builder: (context, state) {
                                if (state.isSearchActive) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      CustomTextFormField(
                                        controller: searchController,
                                        hintTitle: 'Search term',
                                        showClearSuffix: true,
                                        onChanged: (String searchTerm) {
                                          context.read<ArchiveSearchCubit>().updateSearchTerm(searchTerm);
                                        },
                                        validator: () {
                                          return null;
                                        },
                                        suffixButtonAction: () {
                                          if (searchController.text.isEmpty) {
                                            context.read<ArchiveSearchCubit>().toogleSearch();
                                            context.read<UserStatisticsCubit>().resetState();
                                            return;
                                          }
                                          searchController.clear();
                                          context.read<ArchiveSearchCubit>().updateSearchTerm('');
                                        },
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  );
                                }
                                return SizedBox.fromSize();
                              },
                            ),
                            BlocBuilder<ArchiveSearchCubit, ArchiveSearchState>(
                              builder: (context, searchState) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      if (snapshot.data!.docs.isEmpty) {
                                        return const Text('No data found! :(');
                                      }
                                      final pinextTransactionModel = PinextTransactionModel.fromMap(
                                        snapshot.data!.docs[index].data(),
                                      );
                                      final transactionDetailsCard = TransactionDetailsCard(
                                        pinextTransactionModel: pinextTransactionModel,
                                        isLastIndex: index == snapshot.data!.docs.length - 1,
                                      );
                                      context.read<UserStatisticsCubit>().updateStatistics(
                                            amount: double.parse(pinextTransactionModel.amount),
                                            isExpense: pinextTransactionModel.transactionType == 'Expense',
                                            tag: pinextTransactionModel.transactionTag,
                                            tagAmount: double.parse(
                                              pinextTransactionModel.amount,
                                            ),
                                          );
                                      if (state.selectedFilter == 'All transactions') {
                                        if (searchState.isSearchActive) {
                                          if (pinextTransactionModel.details.toLowerCase().contains(searchState.searchTerm.toLowerCase())) {
                                            return transactionDetailsCard;
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        }
                                        return transactionDetailsCard;
                                      } else if (state.selectedFilter == 'Income' && pinextTransactionModel.transactionType == 'Income') {
                                        if (searchState.isSearchActive) {
                                          if (pinextTransactionModel.details.toLowerCase().contains(searchState.searchTerm.toLowerCase())) {
                                            return transactionDetailsCard;
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        }
                                        return transactionDetailsCard;
                                      } else if (state.selectedFilter == 'Expenses' && pinextTransactionModel.transactionType == 'Expense') {
                                        if (searchState.isSearchActive) {
                                          if (pinextTransactionModel.details.toLowerCase().contains(searchState.searchTerm.toLowerCase())) {
                                            return transactionDetailsCard;
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        }
                                        return transactionDetailsCard;
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const _GetStatisticsWidget(),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GetStatisticsWidget extends StatelessWidget {
  const _GetStatisticsWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchiveCubit, ArchiveState>(
      builder: (context, archiveState) {
        final userStatisticsState = context.watch<UserStatisticsCubit>().state;
        if (userStatisticsState.noDataFound) {
          return const SizedBox.shrink();
        }
        return BlocBuilder<ArchiveSearchCubit, ArchiveSearchState>(
          builder: (context, archiveSearchState) {
            return BlocBuilder<UserStatisticsCubit, UserStatisticsState>(
              builder: (context, state) {
                return archiveSearchState.isSearchActive
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Text(
                                'Summary',
                                style: boldTextStyle.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const GetHorizontalBar(),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Builder(
                            builder: (context) {
                              final demoBlocState = context.watch<DemoBloc>().state;
                              return _GetOverviewWidget(
                                isDemoActive: demoBlocState is DemoEnabledState,
                                title: 'Withdrawals',
                                amount: state.totalExpenses.toString(),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 1,
                            width: getWidth(context),
                            color: customBlackColor.withOpacity(.05),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Builder(
                            builder: (context) {
                              final demoBlocState = context.watch<DemoBloc>().state;
                              return _GetOverviewWidget(
                                isDemoActive: demoBlocState is DemoEnabledState,
                                title: 'Diposits',
                                amount: state.totalSavings.toString(),
                              );
                            },
                          ),
                          BlocBuilder<ArchiveCubit, ArchiveState>(
                            builder: (context, state) {
                              final currentMonthTemp = '0${int.parse(currentMonth) + 1}'.length > 2
                                  ? '0${int.parse(currentMonth) + 1}'.substring(1, 3)
                                  : '0${int.parse(currentMonth) + 1}';
                              return int.parse(state.selectedMonth) == int.parse(currentMonthTemp) - 2
                                  ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                          height: 1,
                                          width: getWidth(context),
                                          color: customBlackColor.withOpacity(.05),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final state = context.watch<UserBloc>().state;
                                            final demoBlocState = context.watch<DemoBloc>().state;

                                            var totalEarnings = '';
                                            if (state is AuthenticatedUserState) {
                                              totalEarnings = state.monthlyEarnings;
                                            }
                                            return _GetOverviewWidget(
                                              isDemoActive: demoBlocState is DemoEnabledState,
                                              title: "You've earned",
                                              amount: totalEarnings,
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                          height: 1,
                                          width: getWidth(context),
                                          color: customBlackColor.withOpacity(.05),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final state = context.watch<UserBloc>().state;
                                            final demoBlocState = context.watch<DemoBloc>().state;

                                            var totalSavings = '';
                                            if (state is AuthenticatedUserState) {
                                              totalSavings = state.monthlySavings;
                                            }
                                            return _GetOverviewWidget(
                                              isDemoActive: demoBlocState is DemoEnabledState,
                                              title: "You've saved",
                                              amount: totalSavings,
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : const SizedBox();
                            },
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 1,
                            width: getWidth(context),
                            color: customBlackColor.withOpacity(.05),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Builder(
                            builder: (context) {
                              final state = context.watch<UserBloc>().state;
                              final demoBlocState = context.watch<DemoBloc>().state;
                              var netWorth = '';
                              if (state is AuthenticatedUserState) {
                                netWorth = state.netBalance;
                              }
                              return _GetOverviewWidget(
                                isDemoActive: demoBlocState is DemoEnabledState,
                                title: 'Current NET. balance',
                                amount: netWorth,
                              );
                            },
                          ),
                          const _GetTransactionHistryOverviewWidget(),
                        ],
                      );
              },
            );
          },
        );
      },
    );
  }
}

class _GetTransactionHistryOverviewWidget extends StatelessWidget {
  const _GetTransactionHistryOverviewWidget();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final archiveState = context.watch<ArchiveCubit>().state;
        final state = context.watch<UserStatisticsCubit>().state;
        final demoBlocState = context.watch<DemoBloc>().state;
        final currentMonthTemp =
            '0${int.parse(currentMonth) + 1}'.length > 2 ? '0${int.parse(currentMonth) + 1}'.substring(1, 3) : '0${int.parse(currentMonth) + 1}';
        return int.parse(archiveState.selectedMonth) != int.parse(currentMonthTemp) - 2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        'Overview',
                        style: boldTextStyle.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const GetHorizontalBar(),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Column(
                    children: [
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Income',
                        amount: state.income.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Food and Groceries',
                        amount: state.foodAndGroceries.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Transportation',
                        amount: state.transportation.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Housing and Utilities',
                        amount: state.transportation.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Health and Wellness',
                        amount: state.healthAndWellness.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Education and Training',
                        amount: state.educationAndTraining.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Entertainment and Leisure',
                        amount: state.entertainmentAndLeisure.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Personal Care',
                        amount: state.personalCare.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Clothing and Accessories',
                        amount: state.clothingAndAccessories.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Gifts and Donations',
                        amount: state.giftsAndDonations.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Miscellaneous',
                        amount: state.miscellaneous.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Others',
                        amount: state.others.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Transferred',
                        amount: state.transfer.toString(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 1,
                        width: getWidth(context),
                        color: customBlackColor.withOpacity(.05),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _GetOverviewWidget(
                        isDemoActive: demoBlocState is DemoEnabledState,
                        title: 'Subscriptions',
                        amount: state.subscription.toString(),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox();
      },
    );
  }
}

class _GetOverviewWidget extends StatelessWidget {
  _GetOverviewWidget({
    required this.isDemoActive,
    required this.title,
    required this.amount,
  });
  bool isDemoActive;
  String title;
  String amount;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title: ',
          style: regularTextStyle.copyWith(
            color: customBlackColor.withOpacity(.80),
          ),
        ),
        BlocBuilder<RegionCubit, RegionState>(
          builder: (context, state) {
            return Text(
              isDemoActive ? '100000 ${state.countryData.symbol}' : '$amount ${state.countryData.symbol}.',
              style: boldTextStyle.copyWith(
                color: primaryColor,
              ),
            );
          },
        ),
      ],
    );
  }
}
