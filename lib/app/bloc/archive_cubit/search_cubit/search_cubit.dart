import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class ArchiveSearchCubit extends Cubit<ArchiveSearchState> {
  ArchiveSearchCubit()
      : super(
          ArchiveSearchDefaultState(
            isSearchActive: false,
            searchTerm: '',
          ),
        );
  void toogleSearch() {
    emit(
      ArchiveSearchDefaultState(
        isSearchActive: !state.isSearchActive,
        searchTerm: '',
      ),
    );
  }

  void resetState() {
    emit(
      ArchiveSearchDefaultState(
        isSearchActive: false,
        searchTerm: '',
      ),
    );
  }

  void updateSearchTerm(String srchTerm) {
    emit(
      ArchiveSearchDefaultState(
        isSearchActive: state.isSearchActive,
        searchTerm: srchTerm,
      ),
    );
  }
}
