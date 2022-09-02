import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
          ),
        );

  changeMonth(String selectedMonth) {
    emit(
      ArchiveInitialState(
        selectedMonth: selectedMonth,
        selectedFilter: "All transactions",
      ),
    );
  }

  changeFilter(String selectedFilter) {
    emit(
      ArchiveInitialState(
        selectedMonth: state.selectedMonth,
        selectedFilter: selectedFilter,
      ),
    );
  }
}
