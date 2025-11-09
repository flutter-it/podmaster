import 'dart:io';

import 'package:intl/intl.dart';

import '../common/logging.dart';

extension DateTimeX on DateTime {
  String get podcastTimeStamp => '${year}_${month}_${day}_${hour}_$minute';

  String get unixTimeToDateString {
    var time = '';
    var date = '';

    try {
      final dateTime = this;
      date = DateFormat.yMd(
        Platform.localeName == 'und' ? 'en_US' : Platform.localeName,
      ).format(dateTime);
      time = DateFormat.Hm(
        Platform.localeName == 'und' ? 'en_US' : Platform.localeName,
      ).format(dateTime);
    } on Exception catch (e) {
      printMessageInDebugMode(e);
      return '$date, $time';
    }
    return '$date, $time';
  }
}
