///Handles Supabase api methods.
///
///Currently project uses:
///- Database
///- Edge Functions
library;

import "dart:developer";
import "dart:io";

import "package:meteo_uyari/models/alert.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import 'messagging.dart';

import "../models/city.dart";
import "exceptions.dart";

///Get list of current alerts for [townId] from database function.
Future<List<Alert>> getAlertsRpc(String townId) async {
  await initSupabase();
  final result = await Supabase.instance.client.rpc("get_alerts", params: {
    "filter_town_id": townId
  }).withConverter((data) => [for (final map in data) Alert.fromMap(map)]);
  log("Result $result", name: "getAlertsRpc");
  return result;
}

///Get list of cities available from remote database
Future<List<City>> getCitiesRpc() async {
  await initSupabase();
  final result = await Supabase.instance.client
      .rpc("get_cities")
      .withConverter((data) => [for (final map in data) City.fromMap(map)]);
  log("Result $result", name: "getCitiesRpc");
  return result;
}

///Request a test notification from supabase edge function.
///
///Throws [NetworkException] if can't connect.
Future<void> triggerTestNotification() async {
  final token = await getFcmToken();
  await initSupabase();
  try {
    final response = await Supabase.instance.client.functions
        .invoke("send_test_notification", body: {"fcmToken": token});
    if (response.status != 200) {
      throw const NetworkException();
    }
  } on SocketException catch (_) {
    throw const NetworkException();
  }
}

///Initalize Supabase services.
///
///Safe to call twice.
Future<void> initSupabase({bool localDevEnv = false}) async {
  try {
    await Supabase.initialize(
        url: localDevEnv
            ? "http://127.0.0.1:54321"
            : "https://srdtccwudnoamyjhkojo.supabase.co",
        anonKey: localDevEnv
            ? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
            : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNyZHRjY3d1ZG5vYW15amhrb2pvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkxNzkwNjksImV4cCI6MjAxNDc1NTA2OX0.2PV-c8i0UgDqxzc-jQKHXWXj-cUIaz-MmKjp6dl78uQ");
    log("SUpabase initialized");
  } on AssertionError catch (_) {
    //Exception throws if supabase initialized more than one
    log("Supabase initalized before, skipping");
  }
}
