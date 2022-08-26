part of 'archive_cubit.dart';

abstract class ArchiveState extends Equatable {
  ArchiveState({required this.selectedMonth});
  String selectedMonth;

  @override
  List<Object> get props => [
    selectedMonth,
  ];
}

class ArchiveInitialState extends ArchiveState {
  ArchiveInitialState({required super.selectedMonth});
}
