part of 'archive_cubit.dart';

abstract class ArchiveState extends Equatable {
  ArchiveState({
    required this.selectedMonth,
    required this.selectedFilter,
  });
  String selectedMonth;
  String selectedFilter;

  @override
  List<Object> get props => [
        selectedMonth,
        selectedFilter,
      ];
}

class ArchiveInitialState extends ArchiveState {
  ArchiveInitialState({
    required super.selectedMonth,
    required super.selectedFilter,
  });
}
