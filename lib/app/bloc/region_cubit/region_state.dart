// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'region_cubit.dart';

class RegionState extends Equatable {
  bool isLoading;
  CountryData countryData;
  RegionState({
    required this.isLoading,
    required this.countryData,
  });

  @override
  List<Object> get props => [
        isLoading,
        countryData.hashCode,
        countryData.code,
        countryData.currency,
        countryData.name,
        countryData.symbol,
        countryData.symbolPlacement,
      ];

  RegionState copyWith({
    bool? isLoading,
    CountryData? countryData,
  }) {
    return RegionState(
      isLoading: isLoading ?? this.isLoading,
      countryData: countryData ?? this.countryData,
    );
  }
}
