import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinext/app/API/repo/api_repo.dart';
import 'package:pinext/app/services/handlers/user_handler.dart';
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

  Future<void> updateRegion(CountryData region) async {
    if (!state.isLoading) {
      emit(
        state.copyWith(isLoading: true, countryData: region),
      );
      await Future.delayed(const Duration(seconds: 1));
      await UserHandler().updateUserRegion(region.code);
      emit(
        state.copyWith(isLoading: false, countryData: region),
      );
    }
  }

  Future<void> getRegionFromIp() async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final ipLocationData = await ApiRepo().getIpLocationData();
    emit(state.copyWith(isLoading: false, countryData: CountryHandler().countryList.where((element) => element.code == ipLocationData.country_code2).first));
  }
}
