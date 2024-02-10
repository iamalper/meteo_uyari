import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_uyari/classes/supabase.dart' as supabase;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async => await supabase.initSupabase(localDevEnv: true));
  testWidgets("Get cities", (_) async {
    final cities = await supabase.getCitiesRpc();
    expect(cities, hasLength(81), reason: "81 cities should parsed");
  });

  final allCityCodes = {for (int i = 0; i <= 81; i++) 90001 + (i * 100)};
  final cityCodeVariant = ValueVariant(allCityCodes);
  testWidgets("Get towns for cities", (_) async {
    final citiesFuture = supabase.getTowns();
    await expectLater(citiesFuture, completes);
  }, skip: true);

  testWidgets("Get alerts for towns", (_) async {
    final alerts =
        supabase.getAlertsRpc(cityCodeVariant.currentValue!.toString());
    await expectLater(alerts, completes);
  }, variant: cityCodeVariant);
}
