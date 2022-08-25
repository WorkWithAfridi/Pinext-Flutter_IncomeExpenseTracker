// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'homepage_filter_cubit.dart';

@immutable
abstract class HomepageFilterState extends Equatable{
  String selectedFilter;
  HomepageFilterState({
    required this.selectedFilter,
  });
    @override
  List<Object> get props => [
        selectedFilter,
      ];
}

class FilterState extends HomepageFilterState {
  FilterState({required super.selectedFilter});
}
