import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'archive_month_state.dart';

class ArchiveMonthCubit extends Cubit<ArchiveMonthState> {
  ArchiveMonthCubit()
      : super(
          ArchiveMonth(
            selectedMonth: 'January',
          ),
        );

  changeMonth(String selectedMonth) {
    emit(
      ArchiveMonth(
        selectedMonth: selectedMonth,
      ),
    );
  }
}
