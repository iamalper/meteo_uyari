import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'messagging.dart' as messaging;
import '../models/city.dart';
import 'package:localstore/localstore.dart';

final _db = Localstore.instance;
final _savedCitiesCollection = _db.collection("savedCities");

///Save the city and setup push notifications.
///
///If called for same [city] multiple times, it has no effect.
///
///Returns [false] if notification permission denied by user.
Future<bool> setNotificationForNewCity(City city) async {
  final result = await messaging.setup(city);
  if (result) {
    await _savedCitiesCollection.doc(city.centerId).set(city.toMap);
    log("Notifications set for: $city", name: "Helpers");
  } else {
    log("Notification permission denied.", name: "Helpers");
  }
  return result;
}

///Get all saved [City] objects with [Localstore]
///
///Returns empty [List] if no city saved with [setNotificationForNewCity()]
Future<List<City>> getSavedCities() async {
  final citiesMap = await _savedCitiesCollection.get();
  return citiesMap?.values.map((e) => City.fromMap(e)).toList() ?? [];
}

///Deletes previously saved [city] and unsubscribes from [city] notifications
Future<void> deleteCity(City city) async {
  await Future.wait([
    _savedCitiesCollection.doc(city.centerId).delete(),
    messaging.unsubscribeFromCity(city)
  ]);
  log("$city removed", name: "Helpers");
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
