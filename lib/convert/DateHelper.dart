import 'package:intl/intl.dart';

class DateHelper {
  static DateFormat joursMoisAnnee = DateFormat.yMMMMd('fr_FR');
  static DateFormat moisAnnee = DateFormat.yMMMM('fr_FR');

  static DateTime ajoutMois(DateTime date) {
    switch (date.month) {
      case DateTime.january:
        return date.day > 28
            ? DateTime(date.year, 2, 28)
            : DateTime(date.year, 2, date.day);
      case DateTime.december:
        return DateTime(date.year + 1, 1, date.day);
      default:
        return date.day > 30
            ? DateTime(date.year, date.month + 1, 30)
            : DateTime(date.year, date.month + 1, date.day);
    }
  }
}
