import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinext/app/bloc/archive_cubit/user_statistics_cubit/user_statistics_cubit.dart';
import 'package:pinext/app/models/pinext_transaction_model.dart';
import 'package:pinext/app/services/date_time_services.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';

import '../../services/firebase_services.dart';

part 'archive_state.dart';

class ArchiveCubit extends Cubit<ArchiveState> {
  ArchiveCubit()
      : super(
          ArchiveInitialState(
            selectedMonth: (int.parse(
                      DateTime.now().toString().substring(5, 7),
                    ) -
                    1)
                .toString(),
            selectedFilter: "All transactions",
            selectedYear: currentYear,
            archiveList: const [],
          ),
        );

  getCurrentMonthTransactionArchive(BuildContext context) async {
    var list = [];
    Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseServices()
        .firebaseFirestore
        .collection('pinext_users')
        .doc(UserHandler().currentUser.userId)
        .collection("pinext_transactions")
        .doc(currentYear)
        .collection(currentMonth)
        .get();

    await data.then((snapshot) {
      for (var transaction in snapshot.docs) {
        list.add(PinextTransactionModel.fromMap(transaction.data()));
      }
    });
    emit(
      ArchiveInitialState(
        selectedMonth: state.selectedMonth,
        selectedFilter: state.selectedFilter,
        selectedYear: state.selectedYear,
        archiveList: list,
      ),
    );
    context.read<UserStatisticsCubit>().extractUserStatisticsFromTransactionList(
          context,
          list,
        );
  }

  changeMonth(String selectedMonth) {
    emit(
      ArchiveInitialState(
        selectedMonth: selectedMonth,
        selectedFilter: "All transactions",
        selectedYear: state.selectedYear,
        archiveList: state.archiveList,
      ),
    );
  }

  changeFilter(String selectedFilter) {
    emit(
      ArchiveInitialState(
        selectedMonth: state.selectedMonth,
        selectedFilter: selectedFilter,
        selectedYear: state.selectedYear,
        archiveList: state.archiveList,
      ),
    );
  }

  changeYear(String selectedYear) {
    log("Changing filter");
    emit(
      ArchiveInitialState(
        selectedMonth: state.selectedMonth,
        selectedFilter: state.selectedFilter,
        selectedYear: selectedYear,
        archiveList: state.archiveList,
      ),
    );
  }
}
