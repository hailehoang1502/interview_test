import 'package:intl/intl.dart';

String formatCurrency(int? number) {
  final formatter = NumberFormat("#,###", "en_US");
  return formatter.format(number).replaceAll(',', '.');
}