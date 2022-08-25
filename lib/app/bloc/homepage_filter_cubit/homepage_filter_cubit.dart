import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'homepage_filter_state.dart';

class HomepageFilterCubit extends Cubit<HomepageFilterState> {
  HomepageFilterCubit()
      : super(
          FilterState(
            selectedFilter: 'Overview',
          ),
        );

  changeMenuFilter(String filterName) {
    emit(
      FilterState(selectedFilter: filterName),
    );
  }
}
