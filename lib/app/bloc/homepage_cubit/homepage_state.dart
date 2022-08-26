// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'homepage_cubit.dart';

@immutable
abstract class HomepageState extends Equatable {
  String selectedFilter;
  HomepageState({
    required this.selectedFilter,
  });
  @override
  List<Object> get props => [
        selectedFilter,
      ];
}

class HomepageInitialState extends HomepageState {
  HomepageInitialState({required super.selectedFilter});
}
