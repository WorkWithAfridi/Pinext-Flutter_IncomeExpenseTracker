import 'dart:math';

String formatCurrencyAbbreviated(String value) {
  final suffixes = <String>['', 'k', 'M', 'B', 'T'];

  if (value == '0') return '0';

  final parsedValue = num.parse(value);
  final magnitude = (parsedValue > 0) ? (parsedValue.toString().length - 1) ~/ 3 : (parsedValue.toString().length - 2) ~/ 3;
  final formattedValue = parsedValue / pow(1000, magnitude);

  if (formattedValue >= 1000) {
    return '${(formattedValue / 1000).toStringAsFixed(4)}${suffixes[magnitude + 1]}';
  } else {
    return '${formattedValue.toStringAsFixed(0)}${suffixes[magnitude]}';
  }
}
