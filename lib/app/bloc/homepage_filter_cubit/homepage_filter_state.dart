// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'homepage_filter_cubit.dart';

@immutable
abstract class HomepageFilterState {
  String selectedFilter;
  HomepageFilterState({
    required this.selectedFilter,
  });
}

class FilterState extends HomepageFilterState {
  FilterState({required super.selectedFilter});
}
