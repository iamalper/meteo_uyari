import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/town.dart';
import 'messagging.dart' as messaging;
import 'package:localstore/localstore.dart';

final _db = Localstore.instance;

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
    //This platform method implemented only for android
    //App executes this in standart workflow.
    if (defaultTargetPlatform == TargetPlatform.android) {
      rethrow;
    }
  }
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

///Deletes previously saved [town] and unsubscribes from [town] notifications
Future<void> deleteTown(Town town) async {
  await Future.wait([
    _savedTownsCollection.doc(town.id.toString()).delete(),
    messaging.unsubscribeFromTown(town)
  ]);
  log("$town removed", name: "Helpers");
}
