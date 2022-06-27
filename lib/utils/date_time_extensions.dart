import 'package:flutter/foundation.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

int daysInMonth(DateTime date) {
  var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
  var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
      firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}

extension fromDateTime on DateTime {
  String getFormattedDate(String format) {
    return DateFormat(format).format(this);
  }
}

Future<String> getCurrentTimeZone() async {
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  return currentTimeZone;
}

extension fromString on String {
  String getFormattedDate(
      {@required String fromFormat, @required String toFormat}) {
    try {
      DateTime passedStringDateTime = new DateFormat(fromFormat).parse(this);
      return new DateFormat(toFormat).format(passedStringDateTime);
    } catch (e) {
      return this;
    }
  }

  DateTime getDateTimeFromString({@required String fromFormat}){
    try {
      DateTime passedStringDateTime = new DateFormat(fromFormat).parse(this);
      return passedStringDateTime;
    } catch (e) {
      return DateTime.now();
    }
  }
}
