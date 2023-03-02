part of 'user_statistics_cubit.dart';

abstract class UserStatisticsState extends Equatable {
  UserStatisticsState({
    required this.totalExpenses,
    required this.totalSavings,
    required this.outcome,
    required this.noDataFound,
    required this.income,
    required this.foodAndGroceries,
    required this.transportation,
    required this.housingAndUtilities,
    required this.healthAndWellness,
    required this.educationAndTraining,
    required this.entertainmentAndLeisure,
    required this.personalCare,
    required this.clothingAndAccessories,
    required this.giftsAndDonations,
    required this.miscellaneous,
    required this.others,
    required this.transfer,
    required this.subscription,
  });
  double totalExpenses;
  double totalSavings;
  double outcome;
  bool noDataFound;
  double income;
  double foodAndGroceries;
  double transportation;
  double housingAndUtilities;
  double healthAndWellness;
  double educationAndTraining;
  double entertainmentAndLeisure;
  double personalCare;
  double clothingAndAccessories;
  double giftsAndDonations;
  double miscellaneous;
  double others;
  double transfer;
  double subscription;

  @override
  List<Object> get props => [
        totalExpenses,
        totalSavings,
        outcome,
        noDataFound,
        income,
        foodAndGroceries,
        transportation,
        housingAndUtilities,
        healthAndWellness,
        educationAndTraining,
        entertainmentAndLeisure,
        personalCare,
        clothingAndAccessories,
        giftsAndDonations,
        miscellaneous,
        others,
        transfer,
        subscription,
      ];
}

class UserStatisticsDefaultState extends UserStatisticsState {
  UserStatisticsDefaultState({
    required super.totalExpenses,
    required super.totalSavings,
    required super.outcome,
    required super.noDataFound,
    required super.income,
    required super.foodAndGroceries,
    required super.transportation,
    required super.housingAndUtilities,
    required super.healthAndWellness,
    required super.educationAndTraining,
    required super.entertainmentAndLeisure,
    required super.personalCare,
    required super.clothingAndAccessories,
    required super.giftsAndDonations,
    required super.miscellaneous,
    required super.others,
    required super.transfer,
    required super.subscription,
  });
}
