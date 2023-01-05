import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinext/app/services/firebase_services.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:uuid/uuid.dart';

import '../../API/firebase_directories.dart';
import '../../app_data/app_constants/constants.dart';
import '../../shared/widgets/custom_snackbar.dart';

class FileHandler {
  FileHandler._internal();
  static final FileHandler _fileHandler = FileHandler._internal();
  factory FileHandler() => _fileHandler;

  createReportForMonth(int month, BuildContext context, String selectedYear) async {
    try {
      String selectedMonthInString = months[month];
      month = month + 1;
      String selectedMonth = "0$month".length > 2 ? "0$month".substring(1, 3) : "0$month";
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText("Date");
      sheet.getRangeByName("B1").setText("Details");
      sheet.getRangeByName("C1").setText("Amount");
      sheet.getRangeByName("D1").setText("Transaction Type");
      QuerySnapshot doc = await FirebaseServices()
          .firebaseFirestore
          .collection(USERS_DIRECTORY)
          .doc(FirebaseServices().getUserId())
          .collection(TRANSACTIONS_DIRECTORY)
          .doc(selectedYear)
          .collection(selectedMonth)
          .orderBy(
            "transactionDate",
            descending: true,
          )
          .get();
      int offset = 2;
      double income = 0.0;
      double expense = 0.0;
      int totalTransactions = doc.docs.length;
      if (doc.docs.isNotEmpty) {
        for (int i = 0; i < totalTransactions; i++) {
          log(doc.docs[i]["transactionDate"]);
          String date = doc.docs[i]["transactionDate"];
          String details = doc.docs[i]["details"];
          String amount = doc.docs[i]["amount"];
          String type = doc.docs[i]["transactionType"];
          if (type == "Income") {
            income += double.parse(amount);
          } else if (type == "Expense") {
            expense += double.parse(amount);
          }
          sheet.getRangeByName('A${i + offset}').setText(
                DateFormat('dd-MM-yyyy').format(DateTime.parse(date)),
              );
          sheet.getRangeByName("B${i + offset}").setText(details);
          sheet.getRangeByName("C${i + offset}").setText(amount);
          sheet.getRangeByName("D${i + offset}").setText(type);
        }
      }
      sheet
          .getRangeByName(
            "A${totalTransactions + offset + 1}",
          )
          .setText(
            "Total income: +$income TK",
          );
      sheet
          .getRangeByName(
            "A${totalTransactions + offset + 2}",
          )
          .setText(
            "Total expense: -$expense TK",
          );
      sheet
          .getRangeByName(
            "A${totalTransactions + offset + 3}",
          )
          .setText(
            "Outcome: ${income - expense} TK",
          );
      sheet
          .getRangeByName(
            "A${totalTransactions + offset + 4}",
          )
          .setText(
            "NET. Balance: ${UserHandler().currentUser.netBalance} TK",
          );

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      final String path = (await getApplicationDocumentsDirectory()).path;
      final String fileName = "$path/report${months[month - 1]}-${const Uuid().v4()}.xlsx";
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      file.create();
      OpenFile.open(fileName);
    } catch (err) {
      GetCustomSnackbar(
        title: "Snap",
        message: "Can't open file. An error occurred!",
        snackbarType: SnackbarType.error,
        context: context,
      );
    }
  }
}
