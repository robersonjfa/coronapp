import 'package:intl/intl.dart';

class DateUtils {
  static final dateFormat = DateFormat("yyyy-MM-dd");

  static String dateToString(DateTime date) => dateFormat.format(date);
}