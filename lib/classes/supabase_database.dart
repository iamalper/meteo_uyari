import "dart:io";

import "package:meteo_uyari/models/alert.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "../models/city.dart";
import "exceptions.dart";
import "helpers.dart";

///Get iteratable of [Alert]'s from Supabase Database
Future<Iterable<Alert>> getAlerts(Iterable<City> cities) async {
  final Iterable<Alert> result;
  try {
    await initSupabase();
    result = await Supabase.instance.client
        .from("alerts")
        .select()
        .contains("towns", cities.map((e) => e.centerId).toList())
        .withConverter((data) => data.map((e) => Alert.fromMap(e)));
  } on SocketException catch (_) {
    throw const NetworkException();
  }
  return result;
}
