import 'package:intl/intl.dart';

abstract class Formatter {
  Formatter._();

  static String formatDateTime(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('hh:mm:ss a');
    return dateFormat.format(dateTime);
  }
}
