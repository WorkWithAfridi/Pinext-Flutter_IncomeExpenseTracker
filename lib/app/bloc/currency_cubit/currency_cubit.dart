import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit()
      : super(
          CurrencyState(
            isLoading: false,
            currencySymbol: '',
          ),
        );

  void setCurrencySymbol(String symbol) {
    emit(
      state.copyWith(
        currencySymbol: symbol,
      ),
    );
  }

  Future<void> updateCurrencySymbol(String symbol) async {
    emit(
      state.copyWith(isLoading: true),
    );
  }
}
