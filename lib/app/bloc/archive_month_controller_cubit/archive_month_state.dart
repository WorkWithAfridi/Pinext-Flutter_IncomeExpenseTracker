part of 'archive_month_cubit.dart';

abstract class ArchiveMonthState extends Equatable {
  ArchiveMonthState({required this.selectedMonth});
  String selectedMonth;

  @override
  List<Object> get props => [
    selectedMonth,
  ];
}

class ArchiveMonth extends ArchiveMonthState {
  ArchiveMonth({required super.selectedMonth});
}
