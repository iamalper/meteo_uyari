import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_uyari/classes/firestore.dart';
import 'package:meteo_uyari/classes/get_cities.dart';
import 'package:meteo_uyari/models/alert.dart';
import 'package:meteo_uyari/models/city.dart';

void main() {
  test("Get cities", () async {
    final cities = await getCities();
    expect(cities, hasLength(81), reason: "81 cities should parsed");
  });

  test("Get alerts", () async {
    await expectLater(
        getAlerts([const City(name: "Antalya", centerId: "90701")]), completes);
  });

  test("Equality of Alert objects", () {
    final alert1 = Alert(
        description: "test",
        severity: Severity.red,
        beginTime: DateTime.now(),
        endTime: DateTime.now(),
        no: "23532",
        hadise: Hadise.agricultural,
        towns: [2343, 2344]);
    final alert2 = Alert(
        description: "test2",
        severity: Severity.red,
        beginTime: DateTime.now(),
        endTime: DateTime.now(),
        no: "23532",
        hadise: Hadise.cold,
        towns: [234, 2222]);
    expect(alert1, equals(alert2),
        reason: "Alerts which has same alertNo, should equal");
  });
}
