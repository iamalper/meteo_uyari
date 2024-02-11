import 'package:intl/intl.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/models/formatted_datetime.dart';
import 'package:meteo_uyari/models/town.dart';

String _cityCodeFormat(int cityCode) {
  final formatter = NumberFormat("00");
  return formatter.format(cityCode);
}

final demoAlerts = [
  Alert(
      no: "230134",
      severity: Severity.orange,
      hadise: Hadise.hot,
      description: "deneme deneme",
      towns: {
        for (var i = 1; i <= 81; i++)
          Town(id: int.parse("9${_cityCodeFormat(i)}01"), name: "Test bölgesi")
      },
      beginTime: FormattedDateTime.now(),
      endTime: FormattedDateTime.now()),
  Alert(
      no: "230135",
      severity: Severity.red,
      hadise: Hadise.wind,
      description: "deneme deneme 123 123",
      towns: {
        for (var i = 1; i <= 81; i++)
          Town(
              id: int.parse("9${_cityCodeFormat(i)}01"), name: "Test bölgesi 2")
      },
      beginTime: FormattedDateTime.now(),
      endTime: FormattedDateTime.now())
];
