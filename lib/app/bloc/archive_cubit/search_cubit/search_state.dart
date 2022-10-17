part of 'search_cubit.dart';

abstract class ArchiveSearchState extends Equatable {
  ArchiveSearchState({
    required this.isSearchActive,
    required this.searchTerm,
  });
  String searchTerm;
  bool isSearchActive;

  @override
  List<Object> get props => [
        searchTerm,
        isSearchActive,
      ];
}

class ArchiveSearchDefaultState extends ArchiveSearchState {
  ArchiveSearchDefaultState({required super.isSearchActive, required super.searchTerm});
}
