import "dart:io";

import "package:meteo_uyari/models/alert.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import 'messagging.dart';

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

Future<void> triggerTestNotification() async {
  final token = await fcmToken;
  await initSupabase();
  final response = await Supabase.instance.client.functions
      .invoke("send_test_notification", body: {"fmcToken": token});
  if (response.status != 200) {
    throw const NetworkException();
  }
}
