import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinext/app/API/firebase_directories.dart';
import 'package:pinext/app/app_data/app_constants/constants.dart';
import 'package:pinext/app/app_data/extensions/string_extensions.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/card_handler.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
import 'package:pinext/app/shared/widgets/custom_snackbar.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:uuid/uuid.dart';

class FileHandler {
  factory FileHandler() => _fileHandler;
  FileHandler._internal();
  static final FileHandler _fileHandler = FileHandler._internal();

  Future<void> createReportForMonth(int month, BuildContext context, String selectedYear) async {
    try {
      final selectedMonthInString = months[month];
      month = month + 1;
      final selectedMonth = '0$month'.length > 2 ? '0$month'.substring(1, 3) : '0$month';
      final workbook = Workbook();
      final sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Date');
      sheet.getRangeByName('B1').setText('Card');
      sheet.getRangeByName('C1').setText('Details');
      sheet.getRangeByName('D1').setText('Amount');
      sheet.getRangeByName('E1').setText('Transaction Type');
      QuerySnapshot doc = await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(FirebaseServices().getUserId())
          .collection(TRANSACTIONS_DIRECTORY)
          .doc(selectedYear)
          .collection(selectedMonth)
          .orderBy(
            'transactionDate',
            descending: true,
          )
          .get();
      const offset = 2;
      var income = 0;
      var expense = 0;
      final totalTransactions = doc.docs.length;
      if (doc.docs.isNotEmpty) {
        for (var i = 0; i < totalTransactions; i++) {
          final date = doc.docs[i]['transactionDate'] as String;
          final details = doc.docs[i]['details'].toString().toLowerCase().capitalize();
          final amount = doc.docs[i]['amount'] as String;
          final type = doc.docs[i]['transactionType'] as String;
          final cardId = doc.docs[i]['cardId'] as String;
          final card = await CardHandler().getCardData(cardId);
          if (type == 'Income') {
            income += int.parse(amount);
          } else if (type == 'Expense') {
            expense += int.parse(amount);
          }
          sheet.getRangeByName('A${i + offset}').setText(
                DateFormat('dd-MM-yyyy').format(DateTime.parse(date)),
              );
          sheet.getRangeByName('B${i + offset}').setText(card.title);
          sheet.getRangeByName('C${i + offset}').setText(details.capitalize());
          sheet.getRangeByName('D${i + offset}').setText(amount);
          sheet.getRangeByName('E${i + offset}').setText(type == 'Income' ? 'Deposit' : 'Withdrawal');
        }
      }
      sheet
          .getRangeByName(
            'A${totalTransactions + offset + 1}',
          )
          .setText(
            'Total income: +$income ${UserHandler().currentUser.currencySymbol}',
          );
      sheet
          .getRangeByName(
            'A${totalTransactions + offset + 2}',
          )
          .setText(
            'Total expense: -$expense ${UserHandler().currentUser.currencySymbol}',
          );
      sheet
          .getRangeByName(
            'A${totalTransactions + offset + 3}',
          )
          .setText(
            'Outcome: ${income - expense} ${UserHandler().currentUser.currencySymbol}',
          );
      sheet
          .getRangeByName(
            'A${totalTransactions + offset + 4}',
          )
          .setText(
            'NET. Balance: ${UserHandler().currentUser.netBalance} ${UserHandler().currentUser.currencySymbol}',
          );

      final bytes = workbook.saveAsStream();
      workbook.dispose();
      final path = (await getApplicationDocumentsDirectory()).path;
      final fileName = '$path/report${months[month - 1]}-${const Uuid().v4()}.xlsx';
      final file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      await file.create();
      await OpenFile.open(fileName);
    } catch (err) {
      GetCustomSnackbar(
        title: 'Snap',
        message: "Can't open file. An error occurred!",
        snackbarType: SnackbarType.error,
        context: context,
      );
    }
  }
}
