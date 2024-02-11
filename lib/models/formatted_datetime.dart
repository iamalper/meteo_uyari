import 'package:intl/intl.dart';

///Custom [DateTime] for formatting hour and minute integer values to 2 digits.
///
///Use [formattedHour] and [formattedMinute] for formating time.
class FormattedDateTime extends DateTime {
  final _timeIntFormat = NumberFormat("00");
  String get formattedHour => _timeIntFormat.format(hour);
  String get formattedMinute => _timeIntFormat.format(minute);

  FormattedDateTime.fromMillisecondsSinceEpoch(super.millisecondsSinceEpoch)
      : super.fromMillisecondsSinceEpoch();

  FormattedDateTime.now() : super.now();
  FormattedDateTime(super.year) : super();
}
