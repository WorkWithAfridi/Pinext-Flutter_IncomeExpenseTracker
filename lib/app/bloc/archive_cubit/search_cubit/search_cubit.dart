import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class ArchiveSearchCubit extends Cubit<ArchiveSearchState> {
  ArchiveSearchCubit()
      : super(
          ArchiveSearchDefaultState(
            isSearchActive: false,
            searchTerm: "",
          ),
        );
  toogleSearch() {
    emit(
      ArchiveSearchDefaultState(
        isSearchActive: !state.isSearchActive,
        searchTerm: "",
      ),
    );
  }

  resetState() {
    emit(
      ArchiveSearchDefaultState(
        isSearchActive: false,
        searchTerm: "",
      ),
    );
  }

  updateSearchTerm(String srchTerm) {
    emit(
      ArchiveSearchDefaultState(
        isSearchActive: state.isSearchActive,
        searchTerm: srchTerm,
      ),
    );
  }
}
