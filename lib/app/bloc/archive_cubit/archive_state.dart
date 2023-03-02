part of 'archive_cubit.dart';

abstract class ArchiveState extends Equatable {
  ArchiveState({
    required this.selectedMonth,
    required this.selectedFilter,
    required this.selectedYear,
    required this.archiveList,
  });
  String selectedMonth;
  String selectedYear;
  String selectedFilter;
  List archiveList;

  @override
  List<Object> get props => [
        selectedMonth,
        selectedFilter,
        selectedYear,
        archiveList.length,
        archiveList,
      ];
}

class ArchiveInitialState extends ArchiveState {
  ArchiveInitialState({
    required super.selectedMonth,
    required super.selectedFilter,
    required super.selectedYear,
    required super.archiveList,
  });
}
