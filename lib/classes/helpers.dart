import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/town.dart';
import 'messagging.dart' as messaging;
import '../models/city.dart';
import 'package:localstore/localstore.dart';

final _db = Localstore.instance;
@Deprecated("App no longer use cities. Use _savedTownsCollection instead")
final _savedCitiesCollection = _db.collection("savedCities");
final _savedTownsCollection = _db.collection("savedTowns");

const _platform = MethodChannel("meteo-uyari");

///Set a Notification Channel for Android.
///
///After channel set, some details can't be changed, user should reinstall the app.
///
///It is required for getting notifications foreground.
Future<void> setNotificationChannel(
    String channelId, String channelName) async {
  try {
    await _platform.invokeMethod<void>(
        "initChannel", {"channelId": channelId, "channelName": channelName});
  } on MissingPluginException catch (_) {
    //This platform method implemented onnly for android
    //App executes this in standart workflow.
    if (defaultTargetPlatform == TargetPlatform.android) {
      rethrow;
    }
  }
}

///Save the city and setup push notifications.
///
///If called for same [city] multiple times, it has no effect.
///
///Returns [false] if notification permission denied by user.
@Deprecated("App no longer use cities. Use setNotificationForNewTown instead.")
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

Future<bool> setNotificationForNewTown(Town town) async {
  final result = await messaging.setupForTown(town);
  if (result) {
    await _savedTownsCollection.doc(town.id.toString()).set(town.map);
    log("Notifications set for: $town", name: "Helpers");
  } else {
    log("Notification permission denied.", name: "Helpers");
  }
  return result;
}

///Get all saved [City] objects with [Localstore]
///
///Returns empty [Set] if no city saved with [setNotificationForNewCity()]
@Deprecated("App no longer use cities. Use getSavedTowns instead.")
Future<Set<City>> getSavedCities() async {
  final citiesMap = await _savedCitiesCollection.get();
  final cities = {
    for (final cityMap in citiesMap?.values ?? []) City.fromMap(cityMap)
  };
  return cities;
}

///Get all saved [Town] objects with [Localstore]
///
///Returns empty [Set] if no [Town] saved with [setNotificationForNewTown()]
Future<Set<Town>> getSavedTowns() async {
  final townMaps = await _savedTownsCollection.get();
  final towns = {
    for (final cityMap in townMaps?.values ?? []) Town.fromMap(cityMap)
  };
  return towns;
}

enum MyBuildType { unknown, alpha, beta, stable }

final buildType = switch (const String.fromEnvironment("buildType")) {
  "alpha" => MyBuildType.alpha,
  "beta" => MyBuildType.beta,
  "stable" => MyBuildType.stable,
  _ => MyBuildType.unknown
};

///Deletes previously saved [city] and unsubscribes from [city] notifications
@Deprecated("App no longer use cities. Use deleteTown instead")
Future<void> deleteCity(City city) async {
  await Future.wait([
    _savedCitiesCollection.doc(city.centerId).delete(),
    messaging.unsubscribeFromCity(city)
  ]);
  log("$city removed", name: "Helpers");
}

///Deletes previously saved [town] and unsubscribes from [town] notifications
Future<void> deleteTown(Town town) async {
  await Future.wait([
    _savedTownsCollection.doc(town.id.toString()).delete(),
    messaging.unsubscribeFromTown(town)
  ]);
  log("$town removed", name: "Helpers");
}
