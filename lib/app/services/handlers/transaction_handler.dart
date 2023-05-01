import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/bloc/archive_cubit/archive_cubit.dart';
import 'package:pinext/app/models/pinext_card_model.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
import 'package:uuid/uuid.dart';

class TransactionHandler {
  factory TransactionHandler() => _transactionHandler;

  TransactionHandler._internal();

  static final TransactionHandler _transactionHandler = TransactionHandler._internal();

  Future<String> addTransaction({
    required String amount,
    required String description,
    required String transactionType,
    required String cardId,
    required bool markedAs,
    required String transactionTag,
    required BuildContext context,
  }) async {
    var response = 'Error';
    try {
      final pinextCardModel = await CardHandler().getCard(cardId);
      if (pinextCardModel.balance < double.parse(amount) && transactionType == 'Expense') {
        return "Couldn't process transaction. Low balance!";
      }

      final transactionId = const Uuid().v4();
      final pinextTransactionModel = PinextTransactionModel(
        transactionType: transactionType,
        amount: amount,
        details: description.toLowerCase(),
        cardId: cardId,
        transactionDate: DateTime.now().toString(),
        transactionId: transactionId,
        transactionTag: transactionTag,
      );
      //Adding transaction
      await FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(FirebaseServices().getUserId())
          .collection('pinext_transactions')
          .doc(currentYear)
          .collection(currentMonth)
          .doc(
            transactionId,
          )
          .set(
            pinextTransactionModel.toMap(),
          );

      // Adjust card balance and updating last transaction time

      var adjustedAmount = (transactionType == 'Income') ? pinextCardModel.balance + double.parse(amount) : pinextCardModel.balance - double.parse(amount);

      if (adjustedAmount < 0) {
        adjustedAmount = 0;
      }
      await FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(FirebaseServices().getUserId())
          .collection('pinext_cards')
          .doc(pinextTransactionModel.cardId)
          .update({
        'balance': adjustedAmount,
        'lastTransactionData': DateTime.now().toString(),
      });

      // //Adjusting global balances
      if (markedAs) {
        final pinextUserModel = UserHandler().currentUser;
        if (transactionType == 'Income') {
          final adjustedMonthlySavings = double.parse(pinextUserModel.monthlySavings) + double.parse(amount);
          final adjustedNetBalance = double.parse(pinextUserModel.netBalance) + double.parse(amount);
          final adjustedMonthlyEarnings = pinextUserModel.monthlyEarnings == '' ? 0.0 : double.parse(pinextUserModel.monthlyEarnings) + double.parse(amount);
          await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
            'monthlySavings': adjustedMonthlySavings.toString(),
            'netBalance': adjustedNetBalance.toString(),
            'monthlyEarnings': adjustedMonthlyEarnings.toString(),
          });
          await UserHandler().getCurrentUser();
        } else {
          final adjustedMonthlySavings =
              double.parse(pinextUserModel.monthlySavings) <= 0.0 ? 0.0 : double.parse(pinextUserModel.monthlySavings) - double.parse(amount);
          final adjustedDailyExpenses = double.parse(pinextUserModel.dailyExpenses) + double.parse(amount);
          final adjustedMonthlyExpenses = double.parse(pinextUserModel.monthlyExpenses) + double.parse(amount);
          final adjustedNetBalance = double.parse(pinextUserModel.netBalance) - double.parse(amount);
          final adjustedWeeklyExpenses = double.parse(pinextUserModel.weeklyExpenses) + double.parse(amount);
          await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
            'netBalance': adjustedNetBalance.toString(),
            'dailyExpenses': adjustedDailyExpenses.toString(),
            'monthlyExpenses': adjustedMonthlyExpenses.toString(),
            'monthlySavings': adjustedMonthlySavings.toString(),
            'weeklyExpenses': adjustedWeeklyExpenses.toString(),
          });
        }
      }

      response = 'Success';
    } on FirebaseException catch (err) {
      response = err.message.toString();
    } catch (err) {
      response = err.toString();
    }
    await context.read<ArchiveCubit>().getCurrentMonthTransactionArchive(context);
    return response;
  }

  Future<String> deleteTransaction(
    PinextTransactionModel transactionModel,
    PinextCardModel? cardModel,
  ) async {
    log(cardModel.toString());
    var response = 'An error occured while trying to delete your transaction';
    // try {
    final date = DateTime.parse(transactionModel.transactionDate);
    final month = date.month.toString().length == 1 ? '0${date.month.toString()}' : date.month.toString();

    var updatedBalance = 0.0;

    //Deleting transaction
    await FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(FirebaseServices().getUserId())
        .collection('pinext_transactions')
        .doc(date.year.toString())
        .collection(month)
        .doc(
          transactionModel.transactionId,
        )
        .delete();
    log('Transaction deleted');
    if (cardModel != null) {
      log(cardModel.balance.toString());
      if (transactionModel.transactionTag == 'Income') {
        updatedBalance = double.parse(cardModel.balance.toString()) - double.parse(transactionModel.amount);
      } else {
        updatedBalance = double.parse(cardModel.balance.toString()) + double.parse(transactionModel.amount);
      }
      log('Card updated Balance: #{updatedBalance}');

      await FirebaseServices()
          .firebaseFirestore
          .collection('pinext_users')
          .doc(FirebaseServices().getUserId())
          .collection('pinext_cards')
          .doc(cardModel.cardId)
          .set(
            cardModel
                .copyWith(
                  balance: updatedBalance.toDouble(),
                )
                .toMap(),
          );
    }

    final pinextUserModel = UserHandler().currentUser;
    final amount = transactionModel.amount;

    log('Month: $month');
    log('Year: ${date.year}');

    if (month == currentMonth && date.year.toString() == currentYear) {
      if (transactionModel.transactionType == 'Income') {
        final adjustedMonthlySavings =
            double.parse(pinextUserModel.monthlySavings) <= 0.0 ? 0.0 : double.parse(pinextUserModel.monthlySavings) - double.parse(amount);
        final adjustedNetBalance = double.parse(pinextUserModel.netBalance) <= 0.0 ? 0.0 : double.parse(pinextUserModel.netBalance) - double.parse(amount);
        final adjustedMonthlyEarnings = pinextUserModel.monthlyEarnings == ''
            ? 0.0
            : double.parse(pinextUserModel.monthlyEarnings) <= 0.0
                ? 0.0
                : double.parse(pinextUserModel.monthlyEarnings) - double.parse(amount);
        await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
          'monthlySavings': adjustedMonthlySavings.toInt().toString(),
          'netBalance': adjustedNetBalance.toInt().toString(),
          'monthlyEarnings': adjustedMonthlyEarnings.toInt().toString(),
        });
        await UserHandler().getCurrentUser();
      } else {
        final adjustedMonthlySavings = double.parse(pinextUserModel.monthlySavings) + double.parse(amount);
        final adjustedDailyExpenses =
            double.parse(pinextUserModel.dailyExpenses) <= 0.0 ? 0.0 : double.parse(pinextUserModel.dailyExpenses) - double.parse(amount);
        final adjustedMonthlyExpenses =
            double.parse(pinextUserModel.monthlyExpenses) <= 0.0 ? 0.0 : double.parse(pinextUserModel.monthlyExpenses) - double.parse(amount);
        final adjustedNetBalance = double.parse(pinextUserModel.netBalance) <= 0.0 ? 0.0 : double.parse(pinextUserModel.netBalance) - double.parse(amount);
        final adjustedWeeklyExpenses =
            double.parse(pinextUserModel.weeklyExpenses) <= 0.0 ? 0.0 : double.parse(pinextUserModel.weeklyExpenses) - double.parse(amount);
        await FirebaseServices().firebaseFirestore.collection('pinext_users').doc(FirebaseServices().getUserId()).update({
          'netBalance': adjustedNetBalance.toInt().toString(),
          'dailyExpenses': adjustedDailyExpenses.toInt().toString(),
          'monthlyExpenses': adjustedMonthlyExpenses.toInt().toString(),
          'monthlySavings': adjustedMonthlySavings.toInt().toString(),
          'weeklyExpenses': adjustedWeeklyExpenses.toInt().toString(),
        });
      }
    }

    response = 'Success';
    // } on FirebaseException catch (err) {
    //   response = err.message.toString();
    // } catch (err) {
    //   response = 'An error occured while trying to delete your transaction';
    // }
    return response;
  }
}
