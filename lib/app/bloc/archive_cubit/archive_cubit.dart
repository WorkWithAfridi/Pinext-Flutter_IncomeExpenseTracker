import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/services/date_time_services.dart';

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
            noDataFound: true,
          ),
        );

  changeMonth(String selectedMonth) {
    emit(
      ArchiveInitialState(
        selectedMonth: selectedMonth,
        selectedFilter: "All transactions",
        selectedYear: state.selectedYear,
        noDataFound: state.noDataFound,
      ),
    );
  }

  changeFilter(String selectedFilter) {
    emit(
      ArchiveInitialState(
        selectedMonth: state.selectedMonth,
        selectedFilter: selectedFilter,
        selectedYear: state.selectedYear,
        noDataFound: state.noDataFound,
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
        noDataFound: state.noDataFound,
      ),
    );
  }

  noDataFound(bool status) {
    emit(
      ArchiveInitialState(
        selectedMonth: state.selectedMonth,
        selectedFilter: state.selectedFilter,
        selectedYear: state.selectedYear,
        noDataFound: status,
      ),
    );
  }
}
