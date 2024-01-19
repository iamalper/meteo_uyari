import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/models/city.dart';
import 'package:meteo_uyari/models/formatted_datetime.dart';
import 'package:meteo_uyari/models/town.dart';

void main() {
  test("Equality of Alert objects", () {
    final alert1 = Alert(
        description: "test",
        severity: Severity.red,
        beginTime: FormattedDateTime.now(),
        endTime: FormattedDateTime.now(),
        no: "23532",
        hadise: Hadise.agricultural,
        towns: {
          Town(
              id: 95634,
              parentCity: const City(name: "testşehiri", centerId: "90200")),
          Town(
              id: 95635,
              parentCity: const City(name: "testşehiri2", centerId: "90101"))
        });
    final alert2 = Alert(
        description: "test2",
        severity: Severity.red,
        beginTime: FormattedDateTime.now(),
        endTime: FormattedDateTime.now(),
        no: "23532",
        hadise: Hadise.cold,
        towns: {
          Town(
              id: 93354,
              parentCity: const City(name: "testşehiri2", centerId: "90101")),
          Town(
              id: 93310,
              parentCity: const City(name: "testşehiri", centerId: "90200")),
        });
    expect(alert1, equals(alert2),
        reason: "Alerts which has same alertNo, should equal");
  });
}
