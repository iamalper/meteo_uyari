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
import "../models/town.dart";
import 'messagging.dart';

import "../models/city.dart";
import "exceptions.dart";

///Get iteratable of [Alert]'s from Supabase Database
///
///Throws [NetworkException] if can't connect.
@Deprecated("App no longer use cities, use getAlertsForTowns instead")
Future<Iterable<Alert>> getAlerts(Iterable<City> cities) async {
  final Iterable<Alert> result;
  try {
    await initSupabase();
    result = await Supabase.instance.client
        .from("alerts")
        .select()
        .contains("towns", cities.map((e) => e.id).toList())
        .withConverter((data) => data.map((e) => Alert.fromMap(e)));
  } on SocketException catch (_) {
    throw const NetworkException();
  }
  return result;
}

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

@Deprecated("Use getAlertsRpc which is uses database function")

///Get iteratable of [Alert]'s from Supabase Database
///
///Throws [NetworkException] if can't connect.
Future<Iterable<Alert>> getAlertsForTowns(Set<Town> towns) async {
  final Iterable<Alert> result;
  try {
    await initSupabase();
    result = await Supabase.instance.client
        .from("alerts")
        .select()
        .contains("towns", towns)
        .withConverter((data) => data.map((e) => Alert.fromMap(e)));
  } on SocketException catch (_) {
    throw const NetworkException();
  }
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
    log("SUpabase initalized");
  } on AssertionError catch (_) {
    //Exception throws if supabase initalized more than one
    log("Supabase initalized before, skipping");
  }
}

///Get list of [City]'s available from MeteoUyarı api
Future<List<City>> getCities() async {
  await initSupabase();
  final response = await Supabase.instance.client.functions
      .invoke("get_cities", method: HttpMethod.get);
  if (response.status != 200) {
    log("Cities status code ${response.status}");
    throw const NetworkException();
  }
  final json = response.data as List<dynamic>;
  final cities = json.map((e) => City.fromMap(e)).toList();
  return cities;
}

///Get list of [Town]'s available for [city] from MeteoUyarı api
///
///If [city] is omitted, returns all towns.
Future<List<Town>> getTowns([City? city]) async {
  throw UnimplementedError();
  // ignore: dead_code
  await initSupabase();
  final response = await Supabase.instance.client.functions.invoke("get_towns",
      method: HttpMethod.get, body: city != null ? {"cityId": city.id} : null);
  if (response.status != 200) {
    log("Towns request status code ${response.status}");
    throw const NetworkException();
  }
  final json = response.data as List<dynamic>;
  final towns = [for (final map in json) Town.fromMap(map)];
  return towns;
}

///Get list of towns for [City] with specified [cityId] from remote database
Future<Set<Town>> getTownsRpc(int cityId) async {
  throw UnimplementedError();
// ignore: dead_code
  final result = await Supabase.instance.client.rpc("get_towns", params: {
    "cityId": cityId
  }).withConverter((data) => {for (final map in data) Town.fromMap(map)});
  return result;
}
