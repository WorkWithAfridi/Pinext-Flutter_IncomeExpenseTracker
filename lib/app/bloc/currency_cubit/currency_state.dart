// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'currency_cubit.dart';

class CurrencyState extends Equatable {
  bool isLoading;
  String currencySymbol;
  CurrencyState({
    required this.isLoading,
    required this.currencySymbol,
  });

  @override
  List<Object> get props => [
        isLoading,
        currencySymbol.hashCode,
      ];

  CurrencyState copyWith({
    bool? isLoading,
    String? currencySymbol,
  }) {
    return CurrencyState(
      isLoading: isLoading ?? this.isLoading,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }
}
