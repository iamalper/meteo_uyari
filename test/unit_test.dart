import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_uyari/models/alert.dart';

void main() {
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
