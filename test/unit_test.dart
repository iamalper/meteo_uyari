import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_uyari/classes/helpers.dart' as helpers;
import 'package:meteo_uyari/models/alert.dart';

void main() {
  test("Get cities", () async {
    final cities = await helpers.getCities();
    expect(cities, hasLength(81), reason: "81 cities should parsed");
  });

  test("Get alerts", () async {
    await expectLater(helpers.getAlerts(90701), completes); //Antalya
  });

  test("Equality of Alert objects", () {
    final alert1 = Alert(
        description: "test",
        color: Colors.yellow,
        beginTime: DateTime.now(),
        endTime: DateTime.now(),
        alertNo: "23532");
    final alert2 = Alert(
        description: "test2",
        color: Colors.red,
        beginTime: DateTime.now(),
        endTime: DateTime.now(),
        alertNo: "23532");
    expect(alert1, equals(alert2),
        reason: "Alerts which has same alertNo, should equal");
  });
}
