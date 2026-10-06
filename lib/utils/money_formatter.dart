import 'package:intl/intl.dart';

String formatNaira(dynamic amount) {
  final number = double.tryParse(amount.toString()) ?? 0;

  return NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  ).format(number);
}
