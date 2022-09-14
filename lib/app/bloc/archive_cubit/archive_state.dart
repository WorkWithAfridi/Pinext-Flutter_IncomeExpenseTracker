part of 'archive_cubit.dart';

abstract class ArchiveState extends Equatable {
  ArchiveState(
      {required this.selectedMonth,
      required this.selectedFilter,
      required this.selectedYear});
  String selectedMonth;
  String selectedYear;
  String selectedFilter;

  @override
  List<Object> get props => [selectedMonth, selectedFilter, selectedYear];
}

class ArchiveInitialState extends ArchiveState {
  ArchiveInitialState({
    required super.selectedMonth,
    required super.selectedFilter,
    required super.selectedYear,
  });
}
