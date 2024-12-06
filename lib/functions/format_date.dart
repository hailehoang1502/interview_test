import 'package:intl/intl.dart';

String reverseDateFormat(String date) {
  DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

  return DateFormat("dd-MM-yyyy").format(dateTime);
}