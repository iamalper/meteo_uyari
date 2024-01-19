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
        .contains("towns", cities.map((e) => e.centerId).toList())
        .withConverter((data) => data.map((e) => Alert.fromMap(e)));
  } on SocketException catch (_) {
    throw const NetworkException();
  }
  return result;
}

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
        .contains("towns", towns) //TODO: Test this for set !!
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
Future<void> initSupabase() async {
  try {
    await Supabase.initialize(
        url: "https://srdtccwudnoamyjhkojo.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNyZHRjY3d1ZG5vYW15amhrb2pvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkxNzkwNjksImV4cCI6MjAxNDc1NTA2OX0.2PV-c8i0UgDqxzc-jQKHXWXj-cUIaz-MmKjp6dl78uQ");
    log("SUpabase initalized");
  } on AssertionError catch (_) {
    //Exception throws if supabase initalized more than one
    log("Supabase initalized before, skipping");
  }
}

///Get list of [City]'s available from MeteoUyarı api
@Deprecated("App no longer use cities. Use getTowns instead")
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
      method: HttpMethod.get,
      body: city != null ? {"cityId": city.centerId} : null);
  if (response.status != 200) {
    log("Towns request status code ${response.status}");
    throw const NetworkException();
  }
  final json = response.data as List<dynamic>;
  final towns = [for (final map in json) Town.fromMap(map)];
  return towns;
}
