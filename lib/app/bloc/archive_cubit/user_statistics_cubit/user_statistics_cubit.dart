import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_statistics_state.dart';

class UserStatisticsCubit extends Cubit<UserStatisticsState> {
  UserStatisticsCubit()
      : super(
          UserStatisticsDefaultState(
            totalExpenses: 0,
            totalSavings: 0,
            outcome: 0,
            noDataFound: true,
            income: 0,
            foodAndGroceries: 0,
            transportation: 0,
            housingAndUtilities: 0,
            healthAndWellness: 0,
            educationAndTraining: 0,
            entertainmentAndLeisure: 0,
            personalCare: 0,
            clothingAndAccessories: 0,
            giftsAndDonations: 0,
            miscellaneous: 0,
            others: 0,
            transfer: 0,
            subscription: 0,
          ),
        );

  updateStatistics({
    required double amount,
    required isExpense,
    required tag,
    required double tagAmount,
  }) {
    double totalExpenses = 0;
    double totalSavings = 0;
    double outcome = 0;
    if (isExpense) {
      totalExpenses = state.totalExpenses + amount;
      totalSavings = state.totalSavings;
    } else {
      totalSavings = state.totalSavings + amount;
      totalExpenses = state.totalExpenses;
    }

    switch (tag) {
      case "Income":
        state.income = state.income + tagAmount;
        break;
      case "Food and Groceries":
        state.foodAndGroceries = state.foodAndGroceries + tagAmount;
        break;
      case "Transportation":
        state.transportation = state.transportation + tagAmount;
        break;
      case "Housing and Utilities":
        state.housingAndUtilities = state.housingAndUtilities + tagAmount;
        break;
      case "Health and Wellness":
        state.healthAndWellness = state.healthAndWellness + tagAmount;
        break;
      case "Education and Training":
        state.educationAndTraining = state.educationAndTraining + tagAmount;
        break;
      case "Entertainment and Leisure":
        state.educationAndTraining = state.educationAndTraining + tagAmount;
        break;
      case "Personal Care":
        state.personalCare = state.personalCare + tagAmount;
        break;
      case "Clothing and Accessories":
        state.clothingAndAccessories = state.clothingAndAccessories + tagAmount;
        break;
      case "Gifts and Donations":
        state.giftsAndDonations = state.giftsAndDonations + tagAmount;
        break;
      case "Miscellaneous":
        state.miscellaneous = state.miscellaneous + tagAmount;
        break;
      case "Others":
        state.others = state.others + tagAmount;
        break;
      case "Transfer":
        state.transfer = state.transfer + tagAmount;
        break;
      case "Subscription":
        state.subscription = state.subscription + tagAmount;
        break;
    }

    outcome = totalSavings - totalExpenses;

    emit(UserStatisticsDefaultState(
      totalExpenses: totalExpenses,
      totalSavings: totalSavings,
      outcome: outcome,
      noDataFound: false,
      income: state.income,
      foodAndGroceries: state.foodAndGroceries,
      transportation: state.transportation,
      housingAndUtilities: state.housingAndUtilities,
      healthAndWellness: state.healthAndWellness,
      educationAndTraining: state.educationAndTraining,
      entertainmentAndLeisure: state.entertainmentAndLeisure,
      personalCare: state.personalCare,
      clothingAndAccessories: state.clothingAndAccessories,
      giftsAndDonations: state.giftsAndDonations,
      miscellaneous: state.miscellaneous,
      others: state.others,
      transfer: state.transfer,
      subscription: state.subscription,
    ));
  }

  resetState() {
    emit(
      UserStatisticsDefaultState(
        totalExpenses: 0,
        totalSavings: 0,
        outcome: 0,
        noDataFound: true,
        income: 0,
        foodAndGroceries: 0,
        transportation: 0,
        housingAndUtilities: 0,
        healthAndWellness: 0,
        educationAndTraining: 0,
        entertainmentAndLeisure: 0,
        personalCare: 0,
        clothingAndAccessories: 0,
        giftsAndDonations: 0,
        miscellaneous: 0,
        others: 0,
        transfer: 0,
        subscription: 0,
      ),
    );
  }

  noDataFound(bool status) {
    emit(
      UserStatisticsDefaultState(
        totalExpenses: 0,
        totalSavings: 0,
        outcome: 0,
        noDataFound: true,
        income: 0,
        foodAndGroceries: 0,
        transportation: 0,
        housingAndUtilities: 0,
        healthAndWellness: 0,
        educationAndTraining: 0,
        entertainmentAndLeisure: 0,
        personalCare: 0,
        clothingAndAccessories: 0,
        giftsAndDonations: 0,
        miscellaneous: 0,
        others: 0,
        transfer: 0,
        subscription: 0,
      ),
    );
  }
}
