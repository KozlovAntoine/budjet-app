class DateHelper {
  static bool needCalcul(DateTime dt) {
    DateTime tmp = DateTime(dt.year, dt.month, dt.day);
    print('Date tmp : $tmp');
    return tmp.isBefore(DateTime.now());
  }
}
