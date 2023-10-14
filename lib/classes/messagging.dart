import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/city.dart';

FirebaseMessaging? get _messagging {
  try {
    final instance = FirebaseMessaging.instance;
    log("Firebase messagging initalised", name: "messagging");
    return instance;
  } on FirebaseException catch (_) {
    log("Firebase messagging couldn't initalised", name: "messagging");
    return null;
  }
}

///Setup push notifications for [city] and it's towns.
///
///Returns [false] if permission denied by user.
Future<bool> setup(City city) async {
  final messaging = _messagging;
  if (messaging == null) return true;
  final result = await getPermission();
  if (result) {
    await messaging.deleteToken();
    var futures = <Future<void>>[];
    futures.add(messaging.subscribeToTopic(city.centerId.toString()));
    final towns = city.towns;
    if (towns != null) {
      for (var town in towns) {
        futures.add(messaging.subscribeToTopic(town.toString()));
      }
    }
    await Future.wait(futures);
    return true;
  } else {
    return false;
  }
}

Future<bool> getPermission() async {
  final messaging = _messagging;
  if (messaging == null) return true;
  final result = await messaging.requestPermission();
  return (result.authorizationStatus != AuthorizationStatus.denied);
}

///Returns if notification permissions granted by the user.
///
///Request permission with [getPermission()] or [setup()]
Future<bool> get isPermissionGranted async {
  final messaging = _messagging;
  if (messaging == null) return true;
  return (await messaging.getNotificationSettings()).authorizationStatus ==
      AuthorizationStatus.authorized;
}
