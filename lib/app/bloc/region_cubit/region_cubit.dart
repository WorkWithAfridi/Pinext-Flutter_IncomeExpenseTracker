import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/country_data/country_data.dart';

part 'region_state.dart';

class RegionCubit extends Cubit<RegionState> {
  RegionCubit()
      : super(
          RegionState(
            isLoading: false,
            countryData: CountryHandler().countryList.where((element) => element.code == 'BD').first,
          ),
        );

  void selectRegion(CountryData region) {
    emit(
      state.copyWith(countryData: region),
    );
  }
}
