part of 'archive_cubit.dart';

abstract class ArchiveState extends Equatable {
  ArchiveState({
    required this.selectedMonth,
    required this.selectedFilter,
    required this.selectedYear,
    required this.noDataFound,
  });
  String selectedMonth;
  String selectedYear;
  String selectedFilter;
  bool noDataFound;

  @override
  List<Object> get props => [
        selectedMonth,
        selectedFilter,
        selectedYear,
        noDataFound,
      ];
}

class ArchiveInitialState extends ArchiveState {
  ArchiveInitialState({
    required super.selectedMonth,
    required super.selectedFilter,
    required super.selectedYear,
    required super.noDataFound,
  });
}
