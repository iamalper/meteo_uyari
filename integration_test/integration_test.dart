import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_uyari/classes/supabase.dart' as supabase;
import 'package:meteo_uyari/models/city.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Get cities", (_) async {
    final cities = await supabase.getCities();
    expect(cities, hasLength(81), reason: "81 cities should parsed");
  });

  testWidgets("Get alerts", (_) async {
    await expectLater(
        supabase.getAlerts([const City(name: "Antalya", centerId: "90701")]),
        completes);
  });
}
